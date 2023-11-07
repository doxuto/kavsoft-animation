//
//  Home.swift
//  CustomTFKeyboard
//
//  Created by Balaji on 25/02/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var text: String = ""
    @FocusState private var showKeyboard: Bool
    var body: some View {
        VStack {
            Image("ICON")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
            TextField("$100.0", text: $text)
                .inputView {
                    CustomKeyboardView()
                }
                .focused($showKeyboard)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .environment(\.colorScheme, .dark)
                .padding([.horizontal, .top], 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color("BG").gradient)
                .ignoresSafeArea()
        }
    }
    
    /// Custom Keyboard
    @ViewBuilder
    func CustomKeyboardView() -> some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3), spacing: 10) {
            ForEach(1...9, id: \.self) { index in
                KeyboardButtonView(.text("\(index)")) {
                    /// Adding Text
                    /// Adding Dollar in front
                    if text.isEmpty {
                        text.append("$")
                    }
                    text.append("\(index)")
                }
            }
            
            /// Other Button's With Zero in Center
            KeyboardButtonView(.image("delete.backward")) {
                /// Removing Text One by One
                if !text.isEmpty {
                    text.removeLast()
                    if text == "$" {
                        text = ""
                    }
                }
            }
            
            KeyboardButtonView(.text("0")) {
                /// Adding Dollar in front
                if text.isEmpty {
                    text.append("$")
                }
                text.append("0")
            }
            
            KeyboardButtonView(.image("checkmark.circle.fill")) {
                /// Closing Keyboard
                showKeyboard = false
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .background {
            Rectangle()
                .fill(Color("BG").gradient)
                .ignoresSafeArea()
        }
    }
    
    /// Keyboard Button View
    @ViewBuilder
    func KeyboardButtonView(_ value: KeyboardValue, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            ZStack {
                switch value {
                case .text(let string):
                    Text(string)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                case .image(let image):
                    Image(systemName: image)
                        .font(image == "checkmark.circle.fill" ? .title : .title2)
                        .fontWeight(.semibold)
                        .foregroundColor(image == "checkmark.circle.fill" ? .green : .white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .contentShape(Rectangle())
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Enum Keyboard Value
enum KeyboardValue {
    case text(String)
    case image(String)
}
