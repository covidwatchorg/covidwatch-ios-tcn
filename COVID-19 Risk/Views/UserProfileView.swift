//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sick? 🤒").font(.title)
            Button(action: {
                self.userData.isCurrentUserSick = false
            }) {
                Text("No").font(.title)
            }
            Button(action: {
                self.userData.isCurrentUserSick = true
            }) {
                Text("Yes").font(.title)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(self.userData.isCurrentUserSick ? Color.red : Color.green)
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView()
//    }
//}
