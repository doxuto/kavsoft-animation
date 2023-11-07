//
//  OTPViewModel.swift
//  AutoOTP (iOS)
//
//  Created by Balaji on 14/04/22.
//

import SwiftUI
import Firebase

class OTPViewModel: ObservableObject {
    // MARK: Login Data
    @Published var number: String = ""
    @Published var code: String = ""
    
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6){
        didSet{
            // Checking if OTP is Pressed
            for index in 0..<6{
                if otpFields[index].count == 6{
                    otpText = otpFields[index]
                    otpFields[0] = ""
                    
                    // Updating All TextFields with Value
                    for item in otpText.enumerated(){
                        otpFields[item.offset] = String(item.element)
                    }
                }
            }
        }
    }
    
    // MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMsg: String = ""
    
    // MARK: OTP Credentials
    @Published var verificationCode: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var navigationTag: String?
    @AppStorage("log_status") var log_status = false
    
    // MARK: Sending OTP
    func sendOTP()async{
        if isLoading{return}
        do{
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(code)\(number)", uiDelegate: nil)
            DispatchQueue.main.async {
                self.isLoading = false
                self.verificationCode = result
                self.navigationTag = "VERIFICATION"
            }
        }
        catch{
            handleError(error: error.localizedDescription)
        }
    }
    
    func handleError(error: String){
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMsg = error
            self.showAlert.toggle()
        }
    }
    
    func verifyOTP()async{
        do{
            otpText = otpFields.reduce("") { partialResult, value in
                partialResult + value
            }
            isLoading = true
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
            let _ = try await Auth.auth().signIn(with: credential)
            DispatchQueue.main.async {[self] in
                isLoading = false
                log_status = true
                
            }
        }catch{
            handleError(error: error.localizedDescription)
        }
    }
}
