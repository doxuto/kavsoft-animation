//
//  ContentView.swift
//  InterpolationAPI
//
//  Created by Balaji on 18/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var offset: CGFloat = 0
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var outputValue: CGFloat = 0
    var body: some View {
        // MARK: Eg Use Case
        VStack{
            // MARK: Sample View
            Text("""
Interpolation.shared
    .interpolate(
     inputStartRange: 0,
     inputEndRange: screenWidth,
     outputStartRange: -100,
     outputEndRange: -300,
     value: newValue)

Input Value: \(String(format: "%.1f", offset))
Output Value: \(String(format: "%.1f", outputValue))
""")
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.primary.opacity(0.06))
            }
            .padding(15)
            
            Rectangle()
                .fill(.mint)
                .overlay {
                    Text("Drag Gesture")
                        .foregroundColor(.black)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            offset = value.location.x
                        })
                )
                .onChange(of: offset) { newValue in
                    // MARK: This must be useful for many animations
                    // Inspired from React Native Interpolate Function
                    
                    // MARK: Since Drag Gesture Max X Location will be its Max Screen Width
                    // We Need to Convert Gesture Location Into Series From 0...5
                    outputValue = Interpolation.shared
                        .interpolate(
                         inputStartRange: 0,
                         inputEndRange: screenWidth,
                         outputStartRange: -100,
                         outputEndRange: -300,
                         value: newValue)
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Interpolation Class
class Interpolation{
    // MARK: Singelton
    static let shared = Interpolation()
    
    func interpolate(
        inputStartRange x1: CGFloat,
        inputEndRange x2: CGFloat,
        outputStartRange y1: CGFloat,
        outputEndRange y2: CGFloat,
        value x: CGFloat
    )->CGFloat{
        // MARK: Linear Interpolation Formula
        let y = y1 + ((y2-y1)/(x2-x1)) * (x-x1)
        return y
    }
}
