//
//  Login.swift
//  MultiLogin
//
//  Created by Balaji on 20/08/22.
//

import SwiftUI
// MARK: Intergrating Apple Sign in
// See My Apple Sign in Video For More Detail Procedure
// Link in the Description
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import Firebase

struct Login: View {
    @StateObject var loginModel: LoginViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "triangle")
                    .font(.system(size: 38))
                    .foregroundColor(.indigo)
                
                (Text("Welcome,")
                    .foregroundColor(.black) +
                 Text("\nLogin to continue")
                    .foregroundColor(.gray)
                )
                .font(.title)
                .fontWeight(.semibold)
                .lineSpacing(10)
                .padding(.top,20)
                .padding(.trailing,15)
                
                // MARK: Custom TextField
                CustomTextField(hint: "+1 6505551234", text: $loginModel.mobileNo)
                    .disabled(loginModel.showOTPField)
                    .opacity(loginModel.showOTPField ? 0.4 : 1)
                    .overlay(alignment: .trailing, content: {
                        Button("Change"){
                            withAnimation(.easeInOut){
                                loginModel.showOTPField = false
                                loginModel.otpCode = ""
                                loginModel.CLIENT_CODE = ""
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.indigo)
                        .opacity(loginModel.showOTPField ? 1 : 0)
                        .padding(.trailing,15)
                    })
                    .padding(.top,50)
                
                CustomTextField(hint: "OTP Code", text: $loginModel.otpCode)
                    .disabled(!loginModel.showOTPField)
                    .opacity(!loginModel.showOTPField ? 0.4 : 1)
                    .padding(.top,20)
                
                Button(action: loginModel.showOTPField ? loginModel.verifyOTPCode : loginModel.getOTPCode) {
                    HStack(spacing: 15){
                        Text(loginModel.showOTPField ? "Verify Code" : "Get Code")
                            .fontWeight(.semibold)
                            .contentTransition(.identity)
                        
                        Image(systemName: "line.diagonal.arrow")
                            .font(.title3)
                            .rotationEffect(.init(degrees: 45))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal,25)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black.opacity(0.05))
                    }
                }
                .padding(.top,30)
                
                Text("(OR)")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top,30)
                    .padding(.bottom,20)
                    .padding(.leading,-60)
                    .padding(.horizontal)
                
                HStack(spacing: 8){
                    // MARK: Custom Apple Sign in Button
                    CustomButton()
                    .overlay {
                        SignInWithAppleButton { (request) in
                            loginModel.nonce = randomNonceString()
                            request.requestedScopes = [.email,.fullName]
                            request.nonce = sha256(loginModel.nonce)
                            
                        } onCompletion: { (result) in
                            switch result{
                            case .success(let user):
                                print("success")
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                                    print("error with firebase")
                                    return
                                }
                                loginModel.appleAuthenticate(credential: credential)
                            case.failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 55)
                        .blendMode(.overlay)
                    }
                    .clipped()
                    
                    // MARK: Custom Google Sign in Button
                    CustomButton(isGoogle: true)
                    .overlay {
                        // MARK: We Have Native Google Sign in Button
                        // It's Simple to Integrate Now
                        GoogleSignInButton{
                            Task{
                                do{
                                    let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootController())
                                    
                                    loginModel.logGoogleUser(user: result.user)
                                    
                                }catch{
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        .blendMode(.overlay)
                    }
                    .clipped()
                }
                .padding(.leading,-60)
                .frame(maxWidth: .infinity)
            }
            .padding(.leading,60)
            .padding(.vertical,15)
        }
        .alert(loginModel.errorMessage, isPresented: $loginModel.showError) {
        }
    }
    
    @ViewBuilder
    func CustomButton(isGoogle: Bool = false)->some View{
        HStack{
            Group{
                if isGoogle{
                    Image("Google")
                        .resizable()
                        .renderingMode(.template)
                }else{
                    Image(systemName: "applelogo")
                        .resizable()
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .frame(height: 45)
            
            Text("\(isGoogle ? "Google" : "Apple") Sign in")
                .font(.callout)
                .lineLimit(1)
        }
        .foregroundColor(.white)
        .padding(.horizontal,15)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.black)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
