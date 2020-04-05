//
//  Created by Zsombor Szabo on 05/04/2020.
//

import Foundation
import ContactTracingBluetooth
import ContactTracingCEN
import CryptoKit
import os.log

extension AppDelegate {
    
    // Do not keep the report authorization key around in memory,
    // since contains sensitive information.
    // Fetch it every time from our secure store (Keychain).
    var reportAuthorizationKey: ReportAuthorizationKey {
        do {
            if let storedKey: Curve25519.Signing.PrivateKey = try GenericPasswordStore().readKey(account: "cen-rak") {
                return ReportAuthorizationKey(reportAuthorizationPrivateKey: storedKey)
            }
            else {
                let newKey = Curve25519.Signing.PrivateKey()
                do {
                    try GenericPasswordStore().storeKey(newKey, account: "cen-rak")
                }
                catch {
                    os_log("Storing report authorization key in Keychain failed: %@", log: .app, type: .error, error as CVarArg)
                }
                return ReportAuthorizationKey(reportAuthorizationPrivateKey: newKey)
            }
        }
        catch {
            // Shouldn't get here...
            return ReportAuthorizationKey(reportAuthorizationPrivateKey: Curve25519.Signing.PrivateKey())
        }
    }
    
    // It is safe to store the contact event key in the user defaults,
    // since it does not contain sensitive information.
    var currentContactEventKey: ContactEventKey {
        get {
            if let key = UserDefaults.shared.currentContactEventKey {
                return key
            } else {
                // If there isn't a contact event key in the UserDefaults,
                // then use the initial contact event key.
                return self.reportAuthorizationKey.initialContactEventKey
            }
        }
        set {
            UserDefaults.shared.currentContactEventKey = newValue
        }
    }
    
    func configureContactTracingService() {
        self.contactTracingBluetoothService =
            ContactTracingBluetoothService(
                cenGenerator: { () -> Data in
                    
                    os_log("Bluetooth sharing asked to generate a contact event number to share it", log: .app)
                    
                    let contactEventNumber = self.currentContactEventKey.contactEventNumber
                    
                    // Ratched the key so, we will get a new contact event number the next time
                    if let newContactEventKey = self.currentContactEventKey.ratchet() {
                        self.currentContactEventKey = newContactEventKey
                    }
                    
                    return contactEventNumber.bytes
                    
            }, cenFinder: { (data) in
                
                os_log("Bluetooth sharing found a contact event number from a nearby device: %@", log: .app)
                
                self.logFoundContactEventNumber(with: data)
                
            }, errorHandler: { (error) in
                // TODO: Handle errors, like user not giving permission to access Bluetooth, etc.
                ()
            }
        )
    }
    
    func logFoundContactEventNumber(with bytes: Data) {
        DispatchQueue.main.async {
            let context = PersistentContainer.shared.viewContext
            let contactEvent = ContactEventNumber(context: context)
            contactEvent.bytes = bytes
            contactEvent.foundDate = Date()
            try? context.save()
        }
    }
        
    func generateAndUploadReport() {
        do {
            // Assuming contact event numbers were changed at least every 15 minutes, and the user was infectious in the last 14 days, calculate the start period from the end period.
            let endPeriod = currentContactEventKey.index
            let minutesIn14Days = 60*24*7*2
            let periods = minutesIn14Days / 15
            let startPeriod: UInt16 = UInt16(max(0, Int(endPeriod) - periods))
            
            let cenSignedReport = try self.reportAuthorizationKey.createSignedReport(
                memoType: .CovidWatchV1,
                memoData: "Hello, World!".data(using: .utf8)!,
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
            
            // Create a new Signed Report with `uploadState` set to `.notUploaded` and store it in the local persistent store.
            // This will kick off an observer that watches for signed reports which were not uploaded and will upload it.
            let context = PersistentContainer.shared.viewContext
            let signedReport = SignedReport(context: context)
            signedReport.configure(with: cenSignedReport)
            signedReport.isProcessed = true
            signedReport.uploadState = UploadState.notUploaded.rawValue
            try context.save()
        }
        catch {
            os_log("Generating report failed: %@", log: .app, type: .error)
        }
    }
    
}
