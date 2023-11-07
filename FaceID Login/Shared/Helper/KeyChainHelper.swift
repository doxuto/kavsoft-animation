//
//  KeyChainHelper.swift
//  FaceID Login (iOS)
//
//  Created by Balaji on 03/01/22.
//

import SwiftUI

// MARK: KeyChain helper Class
class KeyChainHelper{
    
    // To Access Class Data
    static let standard = KeyChainHelper()
    
    // MARK: Saving Keychain Value
    func save(data: Data,key: String,account: String){
        
        // Creating Query
        let query = [
        
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Adding Data to KeyChain
        let status = SecItemAdd(query, nil)
        
        // Checking for Status
        switch status{
            
            // Success
        case errSecSuccess: print("Success")
            // Updating Data
        case errSecDuplicateItem:
            let updateQuery = [
                kSecAttrAccount: account,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            // Update Field
            let updateAttr = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(updateQuery, updateAttr)
            
            // Other wise Error
        default: print("Error \(status)")
        }
    }
    
    // MARK: Reading Keychain Data
    func read(key: String,account: String)->Data?{
        
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        // To Copy the data
        var resultData: AnyObject?
        SecItemCopyMatching(query, &resultData)
        
        return (resultData as? Data)
    }
    
    // MARK: Deleting Keychain Data
    func delete(key: String,account: String){
        
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
