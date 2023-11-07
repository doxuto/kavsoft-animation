//
//  Home.swift
//  iPhonePopOvers
//
//  Created by Balaji on 21/01/23.
//

import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var showPopover: Bool = false
    @State private var arrowDirection: ArrowDirection = .up
    @State private var background: Color = .clear
    var body: some View {
        VStack(alignment: .leading,spacing: 12){
            Text("Arrow Direction")
                .font(.caption)
                .foregroundColor(.gray)
            Picker("", selection: $arrowDirection) {
                ForEach(ArrowDirection.allCases,id: \.rawValue){direction in
                    Text(direction.rawValue)
                        .tag(direction)
                }
            }
            .pickerStyle(.segmented)
            
            Text("Background")
                .font(.caption)
                .foregroundColor(.gray)
            Picker("", selection: $background) {
                Text("Default")
                    .tag(Color.clear)
                Text("Blue")
                    .tag(Color.blue)
                Text("Red")
                    .tag(Color.red)
                Text("Orange")
                    .tag(Color.orange)
            }
            .pickerStyle(.segmented)
            
            Button("Show Popover"){
                showPopover.toggle()
            }
            .iOSPopover(isPresented: $showPopover, arrowDirection: arrowDirection.direction) {
                VStack(spacing: 12){
                    Text("Hello, it's me, Popover.")
                        .foregroundColor(background == .clear ? .primary : .white)
                    
                    Button("Close Popover"){
                        showPopover.toggle()
                    }
                    .foregroundColor(background == .clear ? .blue : .white.opacity(0.7))
                }
                .padding(15)
                /// - You can also Give Full Popover Color like this
                .background {
                    Rectangle()
                        .fill(background.gradient)
                        .padding(-20)
                }
            }
            .padding(.top,25)
        }
        .frame(maxHeight: .infinity,alignment: .top)
        .padding(15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Popover Arrow Direction
enum ArrowDirection: String,CaseIterable{
    case up = "Up"
    case down = "Down"
    case left = "Left"
    case right = "Right"
    
    var direction: UIPopoverArrowDirection{
        switch self {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        }
    }
}
