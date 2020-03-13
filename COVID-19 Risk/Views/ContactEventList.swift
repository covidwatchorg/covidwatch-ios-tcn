//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import SwiftUI

struct ContactEventList: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: ContactEvent.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ContactEvent.timestamp, ascending: false)],
        animation: .default
    ) var contactEvents: FetchedResults<ContactEvent>
    
    var body: some View {
        List(self.contactEvents, id: \.self) { contactEvent in
            ContactEventRow(contactEvent: contactEvent)
        }
    }    
}

//struct ContactEventList_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactEventList()
//    }
//}
