//
//  Login.swift
//  AutoOTP (iOS)
//
//  Created by Balaji on 14/04/22.
//

import SwiftUI

struct Login: View {
    @StateObject var otpModel: OTPViewModel = .init()
    var body: some View {
        VStack{
            HStack(spacing: 10){
                VStack(spacing: 8){
                    TextField("1", text: $otpModel.code)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    Rectangle()
                        .fill(otpModel.code == "" ? .gray.opacity(0.35) : .blue)
                        .frame(height: 2)
                }
                .frame(width: 40)
                
                VStack(spacing: 8){
                    TextField("6505551234", text: $otpModel.number)
                        .keyboardType(.numberPad)

                    Rectangle()
                        .fill(otpModel.number == "" ? .gray.opacity(0.35) : .blue)
                        .frame(height: 2)
                }
            }
            .padding(.vertical)
            
            Button {
                Task{await otpModel.sendOTP()}
            } label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .frame(maxWidth: .infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue)
                            .opacity(otpModel.isLoading ? 0 : 1)
                    }
                    .overlay {
                        ProgressView()
                            .opacity(otpModel.isLoading ? 1 : 0)
                    }
            }
            .disabled(otpModel.code == "" || otpModel.number == "")
            .opacity(otpModel.code == "" || otpModel.number == "" ? 0.4 : 1)
        }
        .navigationTitle("Login")
        .padding()
        .frame(maxHeight: .infinity,alignment: .top)
        .background{
            NavigationLink(tag: "VERIFICATION", selection: $otpModel.navigationTag) {
                Verification()
                    .environmentObject(otpModel)
            } label: {}
                .labelsHidden()
        }
        .alert(otpModel.errorMsg, isPresented: $otpModel.showAlert) {}
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
