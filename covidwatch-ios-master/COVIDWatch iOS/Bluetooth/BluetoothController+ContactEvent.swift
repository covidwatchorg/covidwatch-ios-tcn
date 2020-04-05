//
//  Created by Zsombor Szabo on 25/03/2020.
//

import Foundation

extension BluetoothController {
    
    func logNewContactEvent(with identifier: UUID, isBroadcastType: Bool = false) {
        DispatchQueue.main.async {
            let context = PersistentContainer.shared.viewContext
            let contactEvent = ContactEvent(context: context)
            contactEvent.identifier = identifier
            contactEvent.timestamp = Date()
            contactEvent.wasPotentiallyInfectious = UserDefaults.standard.isCurrentUserSick
            contactEvent.isBroadcastType = isBroadcastType
            try? context.save()
        }
    }

}
