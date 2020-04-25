//
//  UserDefaultsExtension.swift
//  CovidWatch iOS
//
//  Created by Jeff Lett on 4/24/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation

/*
 https://forums.swift.org/t/userdefaults-with-generic-keys/6277/3
 
 extension DefaultsKeys {
     static let version = DefaultsKey<String>("version")
 }

 let defaults = UserDefaults.standard
 defaults.set(.version, to: "1.0")
 let version = defaults.get(.version)
 print(version ?? "N/A")
 
 */

class DefaultsKeys {}
final class DefaultsKey<T>: DefaultsKeys {
    let value: String

    init(_ value: String) {
        self.value = value
    }
}

extension UserDefaults {
    func get<T>(_ key: DefaultsKey<T>) -> T? {
        return object(forKey: key.value) as? T
    }

    func set<T>(_ key: DefaultsKey<T>, to value: T) {
        set(value, forKey: key.value)
    }
}

extension DefaultsKeys {
    /// This happens if bluetooth is changed during onboarding and the user
    /// gets bounced back to the start of onboarding when reloading the app
    static let onboardingStarted = DefaultsKey<Bool>("onboardingStarted")
}
