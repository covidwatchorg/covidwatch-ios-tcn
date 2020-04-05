//
// Copyright © 2019 Apple Inc., IZE Ltd. and the project authors
// Licensed under MIT License
//
// See LICENSE.txt for license information.
//

import Foundation
import CryptoKit
import Security

public struct GenericPasswordStore {
    
    public init() {}
    
    /// Stores a CryptoKit key in the keychain as a generic password.
    public func storeKey<T: GenericPasswordConvertible>(
        _ key: T,
        account: String
    ) throws {
        
        // Treat the key data as a generic password.
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecUseDataProtectionKeychain: true,
            kSecValueData: key.rawRepresentation
            ] as [String: Any]
        
        // Add the key data.
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeyStoreError("Unable to store item: \(status.message)")
        }
    }
    
    /// Reads a CryptoKit key from the keychain as a generic password.
    public func readKey<T: GenericPasswordConvertible>(
        account: String
    ) throws -> T? {
        
        // Seek a generic password with the given account.
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecUseDataProtectionKeychain: true,
            kSecReturnData: true
            ] as [String: Any]
        
        // Find and cast the result as data.
        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
            case errSecSuccess:
                guard let data = item as? Data else { return nil }
                return try T(rawRepresentation: data)  // Convert back to a key.
            case errSecItemNotFound:
                return nil
            case let status:
                throw KeyStoreError("Keychain read failed: \(status.message)")
        }
    }
    
    public func readOrCreateKey<T: GenericPasswordConvertible>(
        account: String
    ) throws -> T {
        if let key: T = try readKey(account: account) {
            return key
        }
        else {
            let key = try T()
            try storeKey(key, account: account)
            return key
        }
    }
    
    /// Stores a key in the keychain and then reads it back.
    public func roundTrip<T: GenericPasswordConvertible>(_ key: T) throws -> T {
        
        // An account name for the key in the keychain.
        let account = "com.example.genericpassword.key"
        
        // Start fresh.
        try deleteKey(account: account)
        
        // Store and read it back.
        try storeKey(key, account: account)
        guard let key: T = try readKey(account: account) else {
            throw KeyStoreError("Failed to locate stored key.")
        }
        return key
    }
    
    /// Removes any existing key with the given account.
    public func deleteKey(account: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecUseDataProtectionKeychain: true,
            kSecAttrAccount: account
            ] as [String: Any]
        switch SecItemDelete(query as CFDictionary) {
            case errSecItemNotFound, errSecSuccess: break // Okay to ignore
            case let status:
                throw KeyStoreError("Unexpected deletion error: \(status.message)")
        }
    }
}
