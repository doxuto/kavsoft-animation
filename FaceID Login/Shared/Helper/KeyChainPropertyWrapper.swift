//
//  KeyChainPropertyWrapper.swift
//  FaceID Login (iOS)
//
//  Created by Balaji on 03/01/22.
//

import SwiftUI

// MARK: Custom Wrapper For Keychain
// For easy to use
@propertyWrapper
struct KeyChain: DynamicProperty {

    @State var data: Data?
    
    var wrappedValue: Data?{
        get{KeyChainHelper.standard.read(key: key, account: account)}
        nonmutating set{
            
            guard let newData = newValue else{
                // If we set data to nil
                // Simply delete the Keychain data
                data = nil
                KeyChainHelper.standard.delete(key: key, account: account)
                return
            }
            
            // Updating or Setting KeyChain Data
            KeyChainHelper.standard.save(data: newData, key: key, account: account)
            
            // Updating Data
            data = newValue
        }
    }
    
    var key: String
    var account: String
    
    init(key: String,account: String){
        self.key = key
        self.account = account
        
        // Setting Intial State Keychain Data
        _data = State(wrappedValue: KeyChainHelper.standard.read(key: key, account: account))
    }
}
