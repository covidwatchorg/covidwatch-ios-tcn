//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation
import TCNClient
import CryptoKit
import os.log
import CoreData

extension AppDelegate {
    
    // Do not keep the report authorization key around in memory,
    // since it contains sensitive information.
    // Fetch it every time from our secure store (Keychain).
    var reportAuthorizationKey: ReportAuthorizationKey {
        do {
            if let storedKey: Curve25519.Signing.PrivateKey = try GenericPasswordStore().readKey(account: "tcn-rak") {
                return ReportAuthorizationKey(reportAuthorizationPrivateKey: storedKey)
            } else {
                let newKey = Curve25519.Signing.PrivateKey()
                do {
                    try GenericPasswordStore().storeKey(newKey, account: "tcn-rak")
                } catch {
                    os_log(
                        "Storing report authorization key in Keychain failed: %@",
                        log: .app,
                        type: .error,
                        error as CVarArg
                    )
                }
                return ReportAuthorizationKey(reportAuthorizationPrivateKey: newKey)
            }
        } catch {
            // Shouldn't get here...
            return ReportAuthorizationKey(reportAuthorizationPrivateKey: Curve25519.Signing.PrivateKey())
        }
    }
    
    // It is safe to store the temporary contact key in the user defaults,
    // since it does not contain sensitive information.
    var currentTemporaryContactKey: TemporaryContactKey {
        get {
            if let key = UserDefaults.shared.currentTemporaryContactKey {
                return key
            } else {
                // If there isn't a temporary contact key in the UserDefaults,
                // then use the initial temporary contact key.
                return self.reportAuthorizationKey.initialTemporaryContactKey
            }
        }
        set {
            UserDefaults.shared.currentTemporaryContactKey = newValue
        }
    }
    
    func configureContactTracingService() {
        self.tcnBluetoothService =
            TCNBluetoothService(
                tcnGenerator: { () -> Data in
                    
                    let temporaryContactNumber = self.currentTemporaryContactKey.temporaryContactNumber
                    
                    // Ratched the key so, we will get a new temporary contact
                    // number the next time
                    // TODO: Handle the case when the ratcheting returns nil ->
                    // Update RAK.
                    if let newTemporaryContactKey = self.currentTemporaryContactKey.ratchet() {
                        self.currentTemporaryContactKey = newTemporaryContactKey
                    }
                    
                    self.advertisedTcns.append(temporaryContactNumber.bytes)
                    if self.advertisedTcns.count > 65535 {
                        self.advertisedTcns.removeFirst()
                    }
                    
                    return temporaryContactNumber.bytes
                    
            }, tcnFinder: { (data, estimatedDistance) in
                
                if !self.advertisedTcns.contains(data) {
                    self.logFoundTemporaryContactNumber(with: data, estimatedDistance: estimatedDistance)
                }
                
            }, errorHandler: { (_) in
                // TODO: Handle errors, like user not giving permission to access Bluetooth, etc.
                ()
            }
        )
    }
    
    func logFoundTemporaryContactNumber(with bytes: Data, estimatedDistance: Double?) {
        let now = Date()
        
        let context = PersistentContainer.shared.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        context.perform {
            do {
                let request: NSFetchRequest<TemporaryContactNumber> = TemporaryContactNumber.fetchRequest()
                request.predicate = NSPredicate(format: "bytes == %@", bytes as CVarArg)
                request.fetchLimit = 1
                let results = try context.fetch(request)
                var temporaryContactNumber: TemporaryContactNumber! = results.first
                if temporaryContactNumber == nil {
                    temporaryContactNumber = TemporaryContactNumber(context: context)
                    temporaryContactNumber.bytes = bytes                    
                }
                temporaryContactNumber.lastSeenDate = now
                if let estimatedDistance = estimatedDistance {
                    let currentEstimatedDistance: Double =
                        temporaryContactNumber.closestEstimatedDistanceMeters?.doubleValue ?? .infinity
                    if estimatedDistance < currentEstimatedDistance {
                        temporaryContactNumber.closestEstimatedDistanceMeters = NSNumber(value: estimatedDistance)
                    }
                }
                try context.save()
                os_log("Logged TCN=%@", log: .app, bytes.base64EncodedString())
            } catch {
                os_log("Logging TCN failed: %@", log: .app, type: .error, error as CVarArg)
            }
        }
    }
    
    func generateAndUploadReport() {
        do {
            // Assuming temporary contact numbers were changed at least every
            // 15 minutes, and the user was infectious in the last 14 days,
            // calculate the start period from the end period.
            let endIndex = currentTemporaryContactKey.index
            let minutesIn14Days = 60*24*7*2
            let periods = minutesIn14Days / 15
            let startIndex: UInt16 = UInt16(max(0, Int(endIndex) - periods))
            
            // swiftlint:disable force_unwrapping
            let tcnSignedReport = try self.reportAuthorizationKey.createSignedReport(
                memoType: .CovidWatchV1,
                memoData: "Hello, World!".data(using: .utf8)!,
                startIndex: startIndex,
                endIndex: endIndex
            )
            
            // Create a new Signed Report with `uploadState` set to
            // `.notUploaded` and store it in the local persistent store.
            // This will kick off an observer that watches for signed reports
            // which were not uploaded and will upload it.
            let context = PersistentContainer.shared.viewContext
            let signedReport = SignedReport(context: context)
            signedReport.configure(with: tcnSignedReport)
            signedReport.isProcessed = true
            signedReport.uploadState = UploadState.notUploaded.rawValue
            try context.save()
        } catch {
            os_log("Generating report failed: %@", log: .app, type: .error)
        }
    }
    
}
