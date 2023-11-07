//
//  LoginPageModel.swift
//  EcommerceAppKit (iOS)
//
//  Created by Balaji on 26/11/21.
//

import SwiftUI

class LoginPageModel: ObservableObject {
    
    // Login Properties..
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    
    // Register Properties
    @Published var registerUser: Bool = false
    @Published var re_Enter_Password: String = ""
    @Published var showReEnterPassword: Bool = false
    
    // Log Status...
    @AppStorage("log_Status") var log_Status: Bool = false
    
    // Login Call...
    func Login(){
        // Do Action Here...
        withAnimation{
            log_Status = true
        }
    }
    
    func Register(){
        // Do Action Here...
        withAnimation{
            log_Status = true
        }
    }
    
    func ForgotPassword(){
        // Do Action Here...
    }
}
