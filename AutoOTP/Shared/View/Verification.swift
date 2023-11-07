//
//  Verification.swift
//  AutoOTP (iOS)
//
//  Created by Balaji on 14/04/22.
//

import SwiftUI

struct Verification: View {
    @EnvironmentObject var otpModel: OTPViewModel
    // MARK: TextField FocusState
    @FocusState var activeField: OTPField?
    var body: some View {
        VStack{
            OTPField()
            
            Button {
                Task{await otpModel.verifyOTP()}
            } label: {
                Text("Verify")
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
            .disabled(checkStates())
            .opacity(checkStates() ? 0.4 : 1)
            .padding(.vertical)
            
            HStack(spacing: 12){
                Text("Didn't get otp?")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Button("Resend"){}
                    .font(.callout)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding()
        .frame(maxHeight: .infinity,alignment: .top)
        .navigationTitle("Verification")
        .onChange(of: otpModel.otpFields) { newValue in
            OTPCondition(value: newValue)
        }
        .alert(otpModel.errorMsg, isPresented: $otpModel.showAlert) {}
    }
    
    func checkStates()->Bool{
        for index in 0..<6{
            if otpModel.otpFields[index].isEmpty{return true}
        }
        
        return false
    }
    
    // MARK: Conditions For Custom OTP Field & Limiting Only one Text
    func OTPCondition(value: [String]){
        
        // Moving Next Field If Current Field Type
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField{
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        // Moving Back if Current is Empty And Previous is not Empty
        for index in 1...5{
            if value[index].isEmpty && !value[index - 1].isEmpty{
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        for index in 0..<6{
            if value[index].count > 1{
                otpModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    
    // MARK: Custom OTP TextField
    @ViewBuilder
    func OTPField()->some View{
        HStack(spacing: 14){
            ForEach(0..<6,id: \.self){index in
                VStack(spacing: 8){
                    TextField("", text: $otpModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField,equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? .blue : .gray.opacity(0.3))
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
        }
    }
    
    func activeStateForIndex(index: Int)->OTPField{
        switch index{
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: FocusState Enum
enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
