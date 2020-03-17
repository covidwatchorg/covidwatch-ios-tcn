//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation
import CoreBluetooth
#if canImport(UIKit) && !os(watchOS)
import UIKit.UIApplication
#endif
import os.log
import BerkananFoundation

extension TimeInterval {
    
    public static let peripheralConnectingTimeout: TimeInterval = 8
}

/// The controller responsible for the Bluetooth communication.
class BluetoothController: NSObject {
    
    public let label = UUID().uuidString
    
    @available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    lazy private var log = OSLog(subsystem: label, category: "Bluetooth")
    
    lazy private var dispatchQueue: DispatchQueue =
        DispatchQueue(label: label, qos: .userInteractive)
    
    private var centralManager: CBCentralManager?
    
    private var discoveredPeripherals = Set<CBPeripheral>()
    
    private var connectingTimeoutTimersForPeripheralIdentifiers =
        [UUID : Timer]()
    
    private var connectingPeripheralIdentifiers = Set<UUID>() {
        didSet {
            self.handleConnectingConnectedPeripheralIdentifiersChange()
        }
    }
    
    private var connectedPeripheralIdentifiers = Set<UUID>() {
        didSet {
            self.handleConnectingConnectedPeripheralIdentifiersChange()
        }
    }
    
    private var connectingConnectedPeripheralIdentifiers: Set<UUID> {
        self.connectingPeripheralIdentifiers.union(
            self.connectedPeripheralIdentifiers
        )
    }
    
    private var discoveringServicesPeripheralIdentifiers = Set<UUID>()
    
    private var readingConfigurationCharacteristics = Set<CBCharacteristic>()
    
    #if os(watchOS) || os(tvOS)
    private static let maxNumberOfConcurrentPeripheralConnections = 2
    #else
    private static let maxNumberOfConcurrentPeripheralConnections = 5
    #endif
    
    private var peripheralManager: CBPeripheralManager?
    
    private var peripheralsToReadConfigurationsFrom = Set<CBPeripheral>()
    
    private var peripheralsToConnect: Set<CBPeripheral> {
        return Set(peripheralsToReadConfigurationsFrom)
    }
    
    private func handleConnectingConnectedPeripheralIdentifiersChange() {
        #if canImport(UIKit) && !targetEnvironment(macCatalyst) && !os(watchOS)
        if self.connectingPeripheralIdentifiers.isEmpty &&
            self.connectedPeripheralIdentifiers.isEmpty {
            self.endBackgroundTaskIfNeeded()
        }
        else {
            self.beginBackgroundTaskIfNeeded()
        }
        #endif
    }
    
    // macCatalyst apps do not need background tasks.
    // watchOS apps do not have background tasks.
    #if canImport(UIKit) && !targetEnvironment(macCatalyst) && !os(watchOS)
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    private func beginBackgroundTaskIfNeeded() {
        guard self.backgroundTaskIdentifier == nil else { return }
        self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log("Did expire background task", log: self.log)
            }
            self.endBackgroundTaskIfNeeded()
        }
    }
    
    private func endBackgroundTaskIfNeeded() {
        if let identifier = self.backgroundTaskIdentifier {
            self.backgroundTaskIdentifier = nil
            UIApplication.shared.endBackgroundTask(identifier)
        }
    }
    #endif
    
    override init() {
        super.init()
        // macCatalyst apps do not need background support.
        // watchOS apps do not have background tasks.
        #if canImport(UIKit) && !targetEnvironment(macCatalyst) && !os(watchOS)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillEnterForegroundNotification(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        #endif
    }
    
    deinit {
        #if canImport(UIKit) && !targetEnvironment(macCatalyst) && !os(watchOS)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        #endif
    }
    
    // MARK: - Notifications
    
    @objc func applicationWillEnterForegroundNotification(
        _ notification: Notification
    ) {
        self.dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            // Bug workaround: If Bluetooth was toggled while the app was in the
            // background then scanning fails when the app becomes active.
            // Restart scanning now.
            if self.centralManager?.isScanning ?? false {
                self.centralManager?.stopScan()
                self._startScan()
            }
        }
    }
    
    // MARK: -
    
    /// Returns true if the service is started.
    var isStarted: Bool {
        return self.centralManager != nil
    }
    
    /// Starts the service.
    func start() {
        self.dispatchQueue.async {
            guard self.centralManager == nil else {
                return
            }
            self.centralManager = CBCentralManager(
                delegate: self,
                queue: self.dispatchQueue,
                options: nil
            )
            self.peripheralManager = CBPeripheralManager(
                delegate: self,
                queue: self.dispatchQueue,
                options: [
                    CBPeripheralManagerOptionRestoreIdentifierKey:
                    "covidwatch.peripheral."
            ])
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Service started",
                    log: self.log
                )
            }
        }
    }
    
    /// Stops the service.
    func stop() {
        self.dispatchQueue.async {
            self.stopCentralManager()
            self.centralManager?.delegate = nil
            self.centralManager = nil
            self.stopPeripheralManager()
            self.peripheralManager?.delegate = nil
            self.peripheralManager = nil
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Service stopped",
                    log: self.log
                )
            }
        }
    }
    
    private func stopCentralManager() {
        self.connectingTimeoutTimersForPeripheralIdentifiers.values.forEach {
            $0.invalidate()
        }
        self.connectingTimeoutTimersForPeripheralIdentifiers.removeAll()
        self.discoveredPeripherals.forEach { self.flushPeripheral($0) }
        self.discoveredPeripherals.removeAll()
        self.connectingPeripheralIdentifiers.removeAll()
        self.connectedPeripheralIdentifiers.removeAll()
        self.discoveringServicesPeripheralIdentifiers.removeAll()
        self.readingConfigurationCharacteristics.removeAll()
        self.peripheralsToReadConfigurationsFrom.removeAll()
        if self.centralManager?.isScanning ?? false {
            self.centralManager?.stopScan()
        }
    }
    
    private func stopPeripheralManager() {
        if self.peripheralManager?.isAdvertising ?? false {
            self.peripheralManager?.stopAdvertising()
        }
        if self.peripheralManager?.state == .poweredOn {
            self.peripheralManager?.removeAllServices()
        }
    }
    
    private func connectPeripheralsIfNeeded() {
        guard self.peripheralsToConnect.count > 0 else {
            return
        }
        guard self.connectingConnectedPeripheralIdentifiers.count <
            BluetoothController.maxNumberOfConcurrentPeripheralConnections else {
                return
        }
        let disconnectedPeripherals = self.peripheralsToConnect.filter {
            $0.state == .disconnected || $0.state == .disconnecting
        }
        disconnectedPeripherals.prefix(
            BluetoothController.maxNumberOfConcurrentPeripheralConnections -
                self.connectingConnectedPeripheralIdentifiers.count
        ).forEach {
            self.connectIfNeeded(peripheral: $0)
        }
    }
    
    private func connectIfNeeded(peripheral: CBPeripheral) {
        guard let centralManager = centralManager else {
            return
        }
        if peripheral.state != .connected {
            if peripheral.state != .connecting {
                self.centralManager?.connect(peripheral, options: nil)
                if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                    os_log(
                        "Central manager connecting peripheral (uuid=%@ name='%@')",
                        log: self.log,
                        peripheral.identifier.description,
                        peripheral.name ?? ""
                    )
                }
                self.setupConnectingTimeoutTimer(for: peripheral)
                self.connectingPeripheralIdentifiers.insert(peripheral.identifier)
            }
        }
        else {
            self._centralManager(centralManager, didConnect: peripheral)
        }
    }
    
    private func setupConnectingTimeoutTimer(for peripheral: CBPeripheral) {
        let timer = Timer.init(
            timeInterval: .peripheralConnectingTimeout,
            target: self,
            selector: #selector(_connectingTimeoutTimerFired(timer:)),
            userInfo: ["peripheral" : peripheral],
            repeats: false
        )
        timer.tolerance = 0.5
        RunLoop.main.add(timer, forMode: .common)
        self.connectingTimeoutTimersForPeripheralIdentifiers[
            peripheral.identifier]?.invalidate()
        self.connectingTimeoutTimersForPeripheralIdentifiers[
            peripheral.identifier] = timer
    }
    
    @objc private func _connectingTimeoutTimerFired(timer: Timer) {
        let userInfo = timer.userInfo
        self.dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            guard let userInfo = userInfo as? [AnyHashable : Any],
                let peripheral = userInfo["peripheral"] as? CBPeripheral else {
                    return
            }
            if peripheral.state != .connected {
                if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                    os_log(
                        "Connecting did time out for peripheral (uuid=%@ name='%@')",
                        log: self.log,
                        peripheral.identifier.description,
                        peripheral.name ?? ""
                    )
                }
                self.flushPeripheral(peripheral)
            }
        }
    }
    
    private func flushPeripheral(_ peripheral: CBPeripheral) {
        self.peripheralsToReadConfigurationsFrom.remove(peripheral)
        self.discoveredPeripherals.remove(peripheral)
        self.cancelConnectionIfNeeded(for: peripheral)
    }
    
    private func cancelConnectionIfNeeded(for peripheral: CBPeripheral) {
        self.connectingTimeoutTimersForPeripheralIdentifiers[
            peripheral.identifier]?.invalidate()
        self.connectingTimeoutTimersForPeripheralIdentifiers[
            peripheral.identifier] = nil
        if peripheral.state == .connecting || peripheral.state == .connected {
            self.centralManager?.cancelPeripheralConnection(peripheral)
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Central manager cancelled peripheral (uuid=%@ name='%@') connection",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? ""
                )
            }
        }
        peripheral.delegate = nil
        self.connectingPeripheralIdentifiers.remove(peripheral.identifier)
        self.connectedPeripheralIdentifiers.remove(peripheral.identifier)
        self.discoveringServicesPeripheralIdentifiers.remove(peripheral.identifier)
        peripheral.services?.forEach {
            $0.characteristics?.forEach {
                self.readingConfigurationCharacteristics.remove($0)
            }
        }
        self.connectPeripheralsIfNeeded()
    }
}

extension BluetoothController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Central manager did update state=%@",
                log: self.log,
                String(describing: central.state.rawValue)
            )
        }
        self.stopCentralManager()
        switch central.state {
            case .poweredOn:
                self._startScan()
            default:
                ()
        }
    }
    
    private func _startScan() {
        guard let central = self.centralManager else { return }
        #if targetEnvironment(macCatalyst)
        // CoreBluetooth on macCatalyst doesn't discover services of iOS apps
        // running in the background. Therefore we scan for everything.
        let services: [CBUUID]? = nil
        #else
        let services = [
            CBUUID(string: BluetoothService.UUIDPeripheralServiceString)
        ]
        #endif
        central.scanForPeripherals(
            withServices: services,
            options: [CBCentralManagerScanOptionAllowDuplicatesKey :
              NSNumber(booleanLiteral: true)]
        )
        #if targetEnvironment(macCatalyst)
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Central manager scanning for peripherals with services=%@",
                log: self.log,
                services ?? ""
            )
        }
        #else
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Central manager scanning for peripherals with services=%@",
                log: self.log,
                services
            )
        }
        #endif
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        if !self.discoveredPeripherals.contains(peripheral) {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Central manager did discover new peripheral (uuid=%@ name='%@') RSSI=%d advertisementData=%@",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    RSSI.intValue,
                    advertisementData.description
                )
            }
            if let advertisementDataServiceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID : Data], let uuidData = advertisementDataServiceData[CBUUID(string: BluetoothService.UUIDPeripheralServiceString)],
                let uuid = try? UUID(dataRepresentation: uuidData) {
                self.addNewContactEvent(with: uuid)
            }
            else {
                self.peripheralsToReadConfigurationsFrom.insert(peripheral)
            }
        }
        self.discoveredPeripherals.insert(peripheral)
        self.connectPeripheralsIfNeeded()
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Central manager did connect peripheral (uuid=%@ name='%@')",
                log: self.log,
                peripheral.identifier.description,
                peripheral.name ?? ""
            )
        }
        self.connectingTimeoutTimersForPeripheralIdentifiers[
            peripheral.identifier]?.invalidate()
        self.connectingTimeoutTimersForPeripheralIdentifiers[
            peripheral.identifier] = nil
        self.connectingPeripheralIdentifiers.remove(peripheral.identifier)
        // Bug workaround: Ignore duplicate connect messages from CoreBluetooth
        guard !self.connectedPeripheralIdentifiers.contains(
            peripheral.identifier) else {
                return
        }
        self.connectedPeripheralIdentifiers.insert(peripheral.identifier)
        self._centralManager(central, didConnect: peripheral)
    }
    
    func _centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        self.discoverServices(for: peripheral)
    }
    
    private func discoverServices(for peripheral: CBPeripheral) {
        guard !self.discoveringServicesPeripheralIdentifiers.contains(
            peripheral.identifier) else {
                return
        }
        self.discoveringServicesPeripheralIdentifiers.insert(peripheral.identifier)
        peripheral.delegate = self
        if peripheral.services == nil {
            let services = [
                CBUUID(string: BluetoothService.UUIDPeripheralServiceString)
            ]
            peripheral.discoverServices(services)
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') discovering services=%@",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    services)
            }
        }
        else {
            self._peripheral(peripheral, didDiscoverServices: nil)
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Central manager did fail to connect peripheral (uuid=%@ name='%@') error=%@",
                log: self.log,
                type:.error,
                peripheral.identifier.description,
                peripheral.name ?? "",
                error as CVarArg? ?? ""
            )
        }
        if #available(iOS 12.0, macOS 10.14, macCatalyst 13.0, tvOS 12.0,
            watchOS 5.0, *) {
            if let error = error as? CBError,
                error.code == CBError.operationNotSupported {
                self.peripheralsToReadConfigurationsFrom.remove(peripheral)
            }
        }
        self.cancelConnectionIfNeeded(for: peripheral)
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        if let error = error {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Central manager did disconnect peripheral (uuid=%@ name='%@') error=%@",
                    log: self.log,
                    type:.error,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    error as CVarArg
                )
            }
        }
        else {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Central manager did disconnect peripheral (uuid=%@ name='%@')",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? ""
                )
            }
        }
        self.cancelConnectionIfNeeded(for: peripheral)
    }
}

extension BluetoothController: CBPeripheralDelegate {
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        if let error = error {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') did discover services error=%@",
                    log: self.log,
                    type:.error,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    error as CVarArg
                )
            }
        }
        else {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') did discover services",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? ""
                )
            }
        }
        self._peripheral(peripheral, didDiscoverServices: error)
    }
    
    func _peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        self.discoveringServicesPeripheralIdentifiers.remove(peripheral.identifier)
        guard error == nil else {
            self.cancelConnectionIfNeeded(for: peripheral)
            return
        }
        guard let services = peripheral.services, services.count > 0 else {
            self.peripheralsToReadConfigurationsFrom.remove(peripheral)
            self.cancelConnectionIfNeeded(for: peripheral)
            return
        }
        let servicesWithCharacteristicsToDiscover = services.filter {
            $0.characteristics == nil
        }
        if servicesWithCharacteristicsToDiscover.count == 0 {
            self.startTransfers(for: peripheral)
        }
        else {
            servicesWithCharacteristicsToDiscover.forEach { service in
                let characteristics = [
                    CBUUID(string: BluetoothService.UUIDContactEventIdentifierCharacteristicString),
                ]
                peripheral.discoverCharacteristics(characteristics, for: service)
                if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                    os_log(
                        "Peripheral (uuid=%@ name='%@') discovering characteristics=%@ for service=%@",
                        log: self.log,
                        peripheral.identifier.description,
                        peripheral.name ?? "",
                        characteristics.description,
                        service.description
                    )
                }
            }
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        if let error = error {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') did discover characteristics for service=%@ error=%@",
                    log: self.log,
                    type:.error,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    service.description,
                    error as CVarArg
                )
            }
        }
        else {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') did discover characteristics for service=%@",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    service.description
                )
            }
        }
        guard error == nil, let services = peripheral.services else {
            self.cancelConnectionIfNeeded(for: peripheral)
            return
        }
        let servicesWithCharacteristicsToDiscover = services.filter {
            $0.characteristics == nil
        }
        if servicesWithCharacteristicsToDiscover.count == 0 {
            self.startTransfers(for: peripheral)
        }
    }
    
    private func shouldReadConfigurations(from peripheral: CBPeripheral) -> Bool {
        return self.peripheralsToReadConfigurationsFrom.contains(peripheral)
    }
    
    private func startTransfers(for peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            self.cancelConnectionIfNeeded(for: peripheral)
            return
        }
        services.forEach { service in
            self._peripheral(
                peripheral,
                didDiscoverCharacteristicsFor: service,
                error: nil
            )
        }
    }
    
    func _peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        guard error == nil else {
            self.cancelConnectionIfNeeded(for: peripheral)
            return
        }
        
        // Read configuration, if needed
        if let configurationCharacteristic = service.characteristics?.first(where: {
            $0.uuid == CBUUID(
                string: BluetoothService.UUIDContactEventIdentifierCharacteristicString
            )
        }), self.shouldReadConfigurations(from: peripheral) {
            if !self.readingConfigurationCharacteristics.contains(
                configurationCharacteristic) {
                self.readingConfigurationCharacteristics.insert(
                    configurationCharacteristic)
                peripheral.readValue(for: configurationCharacteristic)
                if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                    os_log(
                        "Peripheral (uuid=%@ name='%@') reading value for characteristic=%@ for service=%@",
                        log: self.log,
                        peripheral.identifier.description,
                        peripheral.name ?? "",
                        configurationCharacteristic.description,
                        service.description
                    )
                }
            }
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        if let error = error {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') did update value for characteristic=%@ for service=%@ error=%@",
                    log: self.log,
                    type:.error,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    characteristic.description,
                    characteristic.service.description,
                    error as CVarArg
                )
            }
        }
        else {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral (uuid=%@ name='%@') did update value=%{iec-bytes}d for characteristic=%@ for service=%@",
                    log: self.log,
                    peripheral.identifier.description,
                    peripheral.name ?? "",
                    characteristic.value?.count ?? 0,
                    characteristic.description,
                    characteristic.service.description
                )
            }
        }
        self.readingConfigurationCharacteristics.remove(characteristic)
        do {
            self.peripheralsToReadConfigurationsFrom.remove(peripheral)
            guard error == nil else {
                self.cancelConnectionIfNeeded(for: peripheral)
                return
            }
            guard let value = characteristic.value else {
                throw CBATTError(.invalidPdu)
            }
            let identifier = try UUID(dataRepresentation: value)
            self.addNewContactEvent(with: identifier)
            self.cancelConnectionIfNeeded(for: peripheral)
        }
        catch {
            self.cancelConnectionIfNeeded(for: peripheral)
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Processing value failed=%@",
                    log: self.log,
                    type:.error,
                    error as CVarArg
                )
            }
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didModifyServices invalidatedServices: [CBService]
    ) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Peripheral (uuid=%@ name='%@') did modify services=%@",
                log: self.log,
                peripheral.identifier.description,
                peripheral.name ?? "",
                invalidatedServices
            )
        }
        if invalidatedServices.contains(where: {
            $0.uuid == CBUUID(string: BluetoothService.UUIDPeripheralServiceString)
        }) {
            self.peripheralsToReadConfigurationsFrom.insert(peripheral)
            self.cancelConnectionIfNeeded(for: peripheral)
        }
    }
}

extension BluetoothController: CBPeripheralManagerDelegate {
    
    func peripheralManager(
        _ peripheral: CBPeripheralManager,
        willRestoreState dict: [String : Any]
    ) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Peripheral manager will restore state",
                log: self.log
            )
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Peripheral manager did update state=%@",
                log: self.log,
                String(describing: peripheral.state.rawValue)
            )
        }
        self._peripheralManagerDidUpdateState(peripheral)
    }
    
    func _peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        //    if #available(OSX 10.15, macCatalyst 13.1, iOS 13.1, tvOS 13.0, watchOS 6.0, *) {
        //      self.service?.bluetoothAuthorization =
        //        BluetoothAuthorization(
        //          cbManagerAuthorization: CBManager.authorization
        //        ) ?? .notDetermined
        //    }
        //    else if #available(OSX 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
        //      self.service?.bluetoothAuthorization =
        //        BluetoothAuthorization(
        //          cbManagerAuthorization: peripheral.authorization
        //        ) ?? .notDetermined
        //    }
        //    else if #available(OSX 10.13, iOS 9.0, *) {
        //      self.service?.bluetoothAuthorization =
        //        BluetoothAuthorization(
        //          cbPeripheralManagerAuthorizationStatus:
        //          CBPeripheralManager.authorizationStatus()
        //        ) ?? .notDetermined
        //    }
        self.stopPeripheralManager()
        switch peripheral.state {
            case .poweredOn:
                let service = BluetoothService.peripheralService
                service.characteristics = [
                    BluetoothService.contactEventIdentifierCharacteristic
                ]
                if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                    os_log(
                        "Peripheral manager adding service=%@",
                        log: self.log,
                        service.description
                    )
                }
                peripheral.add(service)
            default:
                ()
        }
    }
    
    func peripheralManager(
        _ peripheral: CBPeripheralManager,
        didAdd service: CBService,
        error: Error?
    ) {
        if let error = error {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral manager did add service=%@ error=%@",
                    log: self.log,
                    type:.error,
                    service.description,
                    error as CVarArg
                )
            }
        }
        else {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral manager did add service=%@",
                    log: self.log,
                    service.description
                )
            }
            self.startAdvertising()
        }
    }
    
    private func startAdvertising() {
        self.peripheralManager?.startAdvertising(
            [CBAdvertisementDataServiceUUIDsKey :
                [CBUUID(string: BluetoothService.UUIDPeripheralServiceString)]]
        )
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Peripheral manager starting advertising",
                log: self.log
            )
        }
    }
    
    func peripheralManagerDidStartAdvertising(
        _ peripheral: CBPeripheralManager,
        error: Error?
    ) {
        if let error = error {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral manager did start advertising error=%@",
                    log: self.log,
                    type:.error,
                    error as CVarArg
                )
            }
        }
        else {
            if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                os_log(
                    "Peripheral manager did start advertising",
                    log: self.log
                )
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "Peripheral manager did receive read request=%@",
                log: self.log,
                request.description
            )
        }
        let identifier = UUID()
        self.addNewContactEvent(with: identifier)
        request.value = identifier.dataRepresentation
        peripheral.respond(to: request, withResult: .success)
        os_log(
            "Peripheral manager did respond to read request with result=%d",
            log: self.log,
            CBATTError.success.rawValue
        )
    }
    
    private func addNewContactEvent(with identifier: UUID) {
        DispatchQueue.main.async {
            let context = PersistentContainer.shared.viewContext
            let contactEvent = ContactEvent(context: context)
            contactEvent.identifier = identifier
            contactEvent.timestamp = Date()
            contactEvent.wasPotentiallyInfectious = UserDefaults.standard.isCurrentUserSick
            try? context.save()
        }
    }
}
