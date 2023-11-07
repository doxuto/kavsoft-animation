//
//  Home.swift
//  CardCreation
//
//  Created by Balaji on 03/04/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @FocusState private var activeTF: ActiveKeyboardField!
    @State private var cardNumber: String = ""
    @State private var cardHolderName: String = ""
    @State private var cvvCode: String = ""
    @State private var expireDate: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                /// Header View
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Add Card")
                        .font(.title3)
                        .padding(.leading, 10)

                    Spacer(minLength: 0)
                    
                    Button {
                        activeTF = .cardNumber
                        cardNumber = ""
                        expireDate = ""
                        cvvCode = ""
                        cardHolderName = ""
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                    }
                }
                
                CardView()
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Label("Add Card", systemImage: "lock")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue.gradient)
                        }
                }
                /// Disabling Action, Until All Details have been Completely Filled
                .disableWithOpacity(cardNumber.count != 19 || expireDate.count != 5 || cardHolderName.isEmpty || cvvCode.count != 3)
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            /// Keyboard Change Button
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    /// No Button Needed for Last Item
                    if activeTF != .cardHolderName {
                        Button("Next") {
                            switch activeTF {
                            case .cardNumber:
                                activeTF = .expirationDate
                            case .cardHolderName: break
                            case .expirationDate:
                                activeTF = .cvv
                            case .cvv:
                                activeTF = .cardHolderName
                            case .none: break
                            }
                        }
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.linearGradient(colors: [
                    Color("CardGradient1"),
                    Color("CardGradient2")
                ], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            /// Card Details
            VStack(spacing: 10) {
                HStack {
                    TextField("XXXX XXXX XXXX XXXX", text: .init(get: {
                        cardNumber
                    }, set: { value in
                        cardNumber = ""
                        
                        /// Inserting Space For Every 4 Digits
                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let stringIndex = value.index(startIndex, offsetBy: index)
                            cardNumber += String(value[stringIndex])
                            
                            if (index + 1) % 5 == 0 && value[stringIndex] != " " {
                                cardNumber.insert(" ", at: stringIndex)
                            }
                        }
                        
                        /// Removing Empty Space When Going Back
                        if value.last == " " {
                            cardNumber.removeLast()
                        }
                        
                        /// Limiting To 16 Digits
                        /// Including with 3 Spaces (16 + 3 = 19)
                        cardNumber = String(cardNumber.prefix(19))
                    }))
                    .font(.title3)
                    .keyboardType(.numberPad)
                    .focused($activeTF, equals: .cardNumber)
                    
                    Spacer(minLength: 0)
                    
                    Image("Visa")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
                
                HStack(spacing: 8) {
                    TextField("MM/YY", text: .init(get: {
                        expireDate
                    }, set: { value in
                        expireDate = value
                        /// Inserting a slash in the third string position to differentiate between month and year
                        if value.count == 3 && !value.contains("/") {
                            let startIndex = value.startIndex
                            let thirdPosition = value.index(startIndex, offsetBy: 2)
                            expireDate.insert("/", at: thirdPosition)
                        }
                        
                        /// Same As before, Removing / When Going back
                        if value.last == "/" {
                            expireDate.removeLast()
                        }
                        
                        /// Limiting String
                        /// Included with one Slash (4 + 1 = 5)
                        expireDate = String(expireDate.prefix(5))
                    }))
                    .keyboardType(.numberPad)
                    .focused($activeTF, equals: .expirationDate)
                    
                    Spacer(minLength: 0)
                    
                    TextField("CVV", text: .init(get: {
                        cvvCode
                    }, set: { value in
                        cvvCode = value
                        /// Simply Limit to Max 3 Digits
                        cvvCode = String(cvvCode.prefix(3))
                    }))
                    .frame(width: 35)
                    .focused($activeTF, equals: .cvv)
                    .keyboardType(.numberPad)
                    
                    Image(systemName: "questionmark.circle.fill")
                }
                .padding(.top, 15)
                
                Spacer(minLength: 0)
                
                TextField("CARD HOLDER NAME", text: $cardHolderName)
                    .focused($activeTF, equals: .cardHolderName)
                    .submitLabel(.done)
            }
            .padding(20)
            .environment(\.colorScheme, .dark)
            .tint(.white)
        }
        .frame(height: 200)
        .padding(.top, 35)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Disable With Opacity Extension
extension View {
    @ViewBuilder
    func disableWithOpacity(_ status: Bool) -> some View {
        self
            .disabled(status)
            .opacity(status ? 0.6 : 1)
    }
}
