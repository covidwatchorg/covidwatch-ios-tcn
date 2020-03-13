//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import SwiftUI

struct ContactEventRow: View {
    
    @ObservedObject var contactEvent: ContactEvent
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(ContactEventRow.dateFormatter.string(from: self.contactEvent.timestamp!)).font(.body).foregroundColor(.secondary)
            Text(self.contactEvent.identifier?.uuidString ?? "Unknown Peer Identifier").font(.body).foregroundColor(.primary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .background(self.contactEvent.wasPotentiallyInfectious ? Color.red : Color.green)
    }
}

//struct ContactEventRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactEventRow()
//    }
//}
