//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation

final class UserData: ObservableObject  {
    
    public static var shared = UserData()
    
    @Published(key: "isCurrentUserSick")
    var isCurrentUserSick: Bool = false
}
