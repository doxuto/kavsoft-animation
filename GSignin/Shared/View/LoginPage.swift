//
//  LoginPage.swift
//  GSignin (iOS)
//
//  Created by Balaji on 08/11/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginPage: View {
    
    // Loading Indicator...
    @State var isLoading: Bool = false
    
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        
        VStack{
            
            // Top Image....
            Image("OnBoard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: getRect().height / 3)
                .padding(.horizontal,20)
                .offset(y: -10)
            // Background Circle....
                .background(
                
                    Circle()
                        .fill(Color("LightBlue"))
                    // Apllying Sclae...
                    // Simply Apply Scale from bottom...
                    // So it will be perfect..
                        .scaleEffect(2,anchor: .bottom)
                    // Slighly moving...
                        .offset(y: 20)
                )
            
            // Text...
            VStack(spacing: 20){
                
                Text("We currently have over\n740 live roles waiting\nfor you!")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .kerning(1.1)
                    .foregroundColor(Color.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                // Sign In Button....
                
                Button {
                    handleLogin()
                } label: {
                    
                    HStack(spacing: 15){
                        
                        Image("google")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                        
                        Text("Create Account")
                            .font(.title3)
                            .fontWeight(.medium)
                            .kerning(1.1)
                    }
                    .foregroundColor(Color("Blue"))
                    .padding()
                    .frame(maxWidth: .infinity)
                    // Capsuled Border...
                    .background(
                    
                        Capsule()
                            .strokeBorder(Color("Blue"))
                    )
                }
                .padding(.top,25)
                
                // Terms Text...
                if #available(iOS 15, *) {
                    Text(getAttributedString(string: "By creating an account, you are agreeing to our Terms of Service"))
                        .font(.body.bold())
                        .foregroundColor(.gray)
                        .kerning(1.1)
                        .lineSpacing(8)
                        .multilineTextAlignment(.center)
                    // Moving Bottom
                        .frame(maxHeight: .infinity,alignment: .bottom)
                        .padding(.bottom,10)
                } else {
                    // Fallback on earlier versions
                    Text("By creating an account, you are agreeing to our Terms of Service")
                        .font(.body.bold())
                        .foregroundColor(.gray)
                        .kerning(1.1)
                        .lineSpacing(8)
                        .multilineTextAlignment(.center)
                    // Moving Bottom
                        .frame(maxHeight: .infinity,alignment: .bottom)
                        .padding(.bottom,10)
                }
            }
            .padding()
            .padding(.top,40)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .overlay(
        
            ZStack{
                
                if isLoading{
                    Color.black
                        .opacity(0.25)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        )
    }
    
    // Attributed String..
    @available(iOS 15, *)
    func getAttributedString(string: String)->AttributedString{
        
        var attributedString = AttributedString(string)
        
        // Apllying Black color and bold to only Terms of Service Text...
        if let range = attributedString.range(of: "Terms of Service"){
            
            attributedString[range].foregroundColor = .black
            attributedString[range].font = .body.bold()
        }
        
        return attributedString
    }
    
    // handle Login..
    func handleLogin(){
        
        // Google Sign in...
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {[self] user, err in
            
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
              return
            }

            guard
              let authentication = user?.authentication,
              let idToken = authentication.idToken
            else {
                isLoading = false
              return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // Firebase Auth...
            Auth.auth().signIn(with: credential) { result, err in
                
                isLoading = false
                
                if let error = err {
                    print(error.localizedDescription)
                  return
                }
                
                // Displaying User Name...
                guard let user = result?.user else{
                    return
                }
                
                print(user.displayName ?? "Success!")
                
                // Updating User as Logged in
                withAnimation{
                    log_Status = true
                }
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

// Extending View to get SCreen Bounds...
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    // Retreiving RootView COntroller...
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}
