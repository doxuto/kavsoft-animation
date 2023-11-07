//
//  Home.swift
//  DynamicSheet
//
//  Created by Balaji on 08/08/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var showSheet: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var alreadyHavingAccount: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    /// View's Height (Storing For Swipe Calculation)
    @State private var sheetFirstPageHeight: CGFloat = .zero
    @State private var sheetSecondPageHeight: CGFloat = .zero
    @State private var sheetScrollProgress: CGFloat = .zero
    /// Other Properties
    @State private var isKeyboardShowing: Bool = false
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show Sheet") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(30)
        /// Sheet
        .sheet(isPresented: $showSheet, onDismiss: {
            /// Reset Properties
            sheetHeight = .zero
            sheetFirstPageHeight = .zero
            sheetSecondPageHeight = .zero
            sheetScrollProgress = .zero
        }, content: {
            /// Sheet View
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollViewReader(content: { proxy in
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0) {
                            OnBoarding(size)
                                .id("First Page")
                            
                            LoginView(size)
                                .id("Second Page")
                        }
                        /// For Paging Needs to be Enabled
                        .scrollTargetLayout()
                    }
                    /// Enabling Paging ScrollView
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    /// Disbaling ScrollView when Keyboard is Visible
                    .scrollDisabled(isKeyboardShowing)
                    /// Custom Button Which will be Updated over scroll
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            if sheetScrollProgress < 1 {
                                /// Continue Button
                                /// Moving to the Next Page (Using ScrollView Reader)
                                withAnimation(.snappy) {
                                    proxy.scrollTo("Second Page", anchor: .leading)
                                }
                            } else {
                                /// Get Started Button
                                /// YOUR CODE
                            }
                        }, label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .opacity(1 - sheetScrollProgress)
                                /// Adding Some Extra Width for Second Page
                                /// Since Login Text Size is Small Reducing the Size
                                .frame(width: 120 + (sheetScrollProgress * (alreadyHavingAccount ? 0 : 50)))
                                .overlay(content: {
                                    /// Next Page Text
                                    HStack(spacing: 8) {
                                        Text(alreadyHavingAccount ? "Login" : "Get Started")
                                        
                                        Image(systemName: "arrow.right")
                                    }
                                    .fontWeight(.semibold)
                                    .opacity(sheetScrollProgress)
                                })
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(.linearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), in: .capsule)
                        })
                        .padding(15)
                        .offset(y: sheetHeight - 100)
                        /// Moving Button Near to the Next View
                        .offset(y: sheetScrollProgress * -120)
                    }
                })
            })
            /// Presentation Customization
            .presentationCornerRadius(30)
            /// Presentation Detents
            .presentationDetents(sheetHeight == .zero ? [.medium] : [.height(sheetHeight)])
            /// Disabling Swipe to Dismiss
            .interactiveDismissDisabled()
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                isKeyboardShowing = true
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                isKeyboardShowing = false
            })
        })
    }
    
    /// First View (OnBoarding)
    @ViewBuilder
    func OnBoarding(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("Know Everything\nabout the weather")
                .font(.largeTitle.bold())
                .lineLimit(2)
            
            /// Custom Attributed SubTitle
            Text(attributedSubTitle)
                .font(.callout)
                .foregroundStyle(.gray)
        })
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 130)
        .frame(width: size.width, alignment: .leading)
        /// Finding the View's Height
        .heightChangePreference { height in
            sheetFirstPageHeight = height
            /// Since the Sheet Height will be same as the First/Initial Page Height
            sheetHeight = height
        }
    }
    
    var attributedSubTitle: AttributedString {
        let string = "Start now and learn more about local weather instantly"
        var attString = AttributedString(stringLiteral: string)
        if let range = attString.range(of: "local weather") {
            attString[range].foregroundColor = .black
            attString[range].font = .callout.bold()
        }
        
        return attString
    }
    
    /// Second View (Login/Signup View)
    @ViewBuilder
    func LoginView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(alreadyHavingAccount ? "Login" : "Create an Account")
                .font(.largeTitle.bold())
            
            /// Custom TextField
            CustomTF(hint: "Email Address", text: $emailAddress, icon: "envelope")
                .padding(.top, 20)
            
            CustomTF(hint: "*****", text: $password, icon: "lock", isPassword: true)
                .padding(.top, 20)
        }
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 220)
        .overlay(alignment: .bottom, content: {
            /// Other Login/Signup Views
            VStack(spacing: 15) {
                Group {
                    if alreadyHavingAccount {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Create an account") {
                                withAnimation(.snappy) {
                                    alreadyHavingAccount.toggle()
                                }
                            }
                            .tint(.red)
                        }
                        .transition(.push(from: .bottom))
                    } else {
                        HStack(spacing: 4) {
                            Text("Already having an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Login") {
                                withAnimation(.snappy) {
                                    alreadyHavingAccount.toggle()
                                }
                            }
                            .tint(.red)
                        }
                        .transition(.push(from: .top))
                    }
                }
                .font(.callout)
                .textScale(.secondary)
                .padding(.bottom, alreadyHavingAccount ? 0 : 15)
                
                if !alreadyHavingAccount {
                    /// Markup Text
                    Text("By signing up, you're agreeing to our **[Terms & Condition](https://apple.com)** and **[Privacy Policy](https://apple.com)**")
                        .font(.caption)
                    /// Markup Content will be Red
                        .tint(.red)
                    /// Others will be Gray
                        .foregroundStyle(.gray)
                        .transition(.offset(y: 100))
                }
            }
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
            .frame(width: size.width)
        })
        .frame(width: size.width)
        /// Finding the View's Height
        .heightChangePreference { height in
            sheetSecondPageHeight = height
            
            /// Just in Case, if the Second Page Height is Changed
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            sheetHeight = sheetFirstPageHeight + (diff * sheetScrollProgress)
        }
        /// Offset Preference
        .minXChangePreference { minX in
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            /// Truncating Minx between (0 to Screen Width)
            let truncatedMinX = min(size.width - minX, size.width)
            guard truncatedMinX > 0 else { return }
            /// Converting MinX to Progress (0 - 1)
            let progress = truncatedMinX / size.width
            sheetScrollProgress = progress
            /// Adding the Difference Height to the Sheet Height
            sheetHeight = sheetFirstPageHeight + (diff * progress)
        }
    }
}

#Preview {
    ContentView()
}
