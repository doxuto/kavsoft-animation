//
//  Home.swift
//  WalkthroughAnimation
//
//  Created by Balaji on 16/06/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var intros: [Intro] = sampleIntros
    @State private var activeIntro: Intro?
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            VStack(spacing: 0) {
                if let activeIntro {
                    Rectangle()
                        .fill(activeIntro.bgColor)
                        .padding(.bottom, -30)
                        /// Circle And Text
                        .overlay {
                            Circle()
                                .fill(activeIntro.circleColor)
                                .frame(width: 38, height: 38)
                                .background(alignment: .leading, content: {
                                    Capsule()
                                        .fill(activeIntro.bgColor)
                                        .frame(width: size.width)
                                })
                                .background(alignment: .leading) {
                                    Text(activeIntro.text)
                                        .font(.largeTitle)
                                        .foregroundStyle(activeIntro.textColor)
                                        .frame(width: textSize(activeIntro.text))
                                        .offset(x: 10)
                                        /// Moving Text based on text Offset
                                        .offset(x: activeIntro.textOffset)
                                }
                                /// Moving Circle in the Opposite Direction
                                .offset(x: -activeIntro.circleOffset)
                        }
                }
                
                /// Login Buttons
                LoginButtons()
                    .padding(.bottom, safeArea.bottom)
                    .padding(.top, 10)
                    .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
            }
            .ignoresSafeArea()
        }
        .task {
            if activeIntro == nil {
                activeIntro = sampleIntros.first
                /// Delaying 0.25s and Starting Animation
                let nanoSeconds = UInt64(1_000_000_000 * 0.25)
                try? await Task.sleep(nanoseconds: nanoSeconds)
                animate(0)
            }
        }
    }
    
    /// Login Buttons
    @ViewBuilder
    func LoginButtons() -> some View {
        VStack(spacing: 12) {
            Button {
                
            } label: {
                Label("Continue With Apple", systemImage: "applelogo")
                    .foregroundStyle(.black)
                    .fillButton(.white)
            }

            Button {
                
            } label: {
                Label("Continue With Phone", systemImage: "phone.fill")
                    .foregroundStyle(.white)
                    .fillButton(.buton)
            }
            
            Button {
                
            } label: {
                Label("Sign Up With Email", systemImage: "envelope.fill")
                    .foregroundStyle(.white)
                    .fillButton(.buton)
            }
            
            Button {
                
            } label: {
                Text("Login")
                    .foregroundStyle(.white)
                    .fillButton(.black)
                    .shadow(color: .white, radius: 1)
            }
        }
        .padding(15)
    }
    
    /// Animating Intros
    func animate(_ index: Int, _ loop: Bool = true) {
        if intros.indices.contains(index + 1) {
            /// Updating Text and Text Color
            activeIntro?.text = intros[index].text
            activeIntro?.textColor = intros[index].textColor
            
            /// Animating Offsets
            withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
                activeIntro?.textOffset = -(textSize(intros[index].text) + 20)
                activeIntro?.circleOffset = -(textSize(intros[index].text) + 20) / 2
            } completion: {
                /// Resetting the Offset with Next Slide Color Change
                withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
                    activeIntro?.textOffset = 0
                    activeIntro?.circleOffset = 0
                    activeIntro?.circleColor = intros[index + 1].circleColor
                    activeIntro?.bgColor = intros[index + 1].bgColor
                } completion: {
                    /// Going to Next Slide
                    /// Simply Recursion
                    animate(index + 1, loop)
                }
            }
        } else {
            /// Looping
            /// If looping Applied, Then Reset the Index to 0
            if loop {
                animate(0, loop)
            }
        }
    }
    
    /// Fetching Text Size based on Fonts
    func textSize(_ text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
}

#Preview {
    ContentView()
}

/// Custom Modifier
extension View {
    @ViewBuilder
    func fillButton(_ color: Color) -> some View {
        self
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color, in: .rect(cornerRadius: 15))
    }
}
