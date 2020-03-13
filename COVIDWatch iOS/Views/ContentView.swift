//
//  Created by Zsombor Szabo on 11/03/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    
    @State private var selection = 0
    
    @State private var region: MKCoordinateRegion?
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        TabView(selection: $selection){
            MapView(region: $region)
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("Heat Map")
                    }
            }
            .tag(0)
            ContactEventList()
                .tabItem {
                    VStack {
                        Image(systemName: "person.3")
                        Text("Contact Events")
                    }
            }
            .tag(1)
            UserProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.circle")
                        Text("My Profile")
                    }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
