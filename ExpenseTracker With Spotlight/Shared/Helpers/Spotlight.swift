//
//  Spotlight.swift
//  ExpenseTracker (iOS)
//
//  Created by Balaji on 17/07/22.
//

import SwiftUI

extension View{
    // MARK: New Modifier For Adding Elements for Spotlight Preview
    @ViewBuilder
    func addSpotlight(_ order: Int,shape: SpotlightShape = .rectangle,roundedRadius: CGFloat = 0,text: String = "")->some View{
        self
        // MARK: Using Anchor Preference For Retreiving View's Bounds Region
            .anchorPreference(key: BoundsKey.self, value: .bounds) {[order: BoundsKeyProperties(shape: shape, anchor: $0, text: text, radius: roundedRadius)]}
    }
    
    // MARK: Modifier to Displaying Spotlight Content
    // NOTE: Add to Root View
    @ViewBuilder
    func addSpotlightOverlay(show: Binding<Bool>,currentSpot: Binding<Int>)->some View{
        self
            .overlayPreferenceValue(BoundsKey.self) { values in
                // For More About Overlay Preference And Anchor Preference
                // Watch My Advanced Transitions Video
                // Link In Description
                GeometryReader{proxy in
                    if let preference = values.first(where: { item in
                        item.key == currentSpot.wrappedValue
                    }){
                        let screenSize = proxy.size
                        let anchor = proxy[preference.value.anchor]
                        
                        // MARK: Spotlight View
                        SpotlightHelperView(screenSize: screenSize, rect: anchor,show: show,currentSpot: currentSpot,properties: preference.value){
                            if currentSpot.wrappedValue <= (values.count){
                                currentSpot.wrappedValue += 1
                            }else{
                                show.wrappedValue = false
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .animation(.easeInOut, value: show.wrappedValue)
                .animation(.easeInOut, value: currentSpot.wrappedValue)
            }
    }
    
    // MARK: Helper View
    @ViewBuilder
    func SpotlightHelperView(screenSize: CGSize,rect: CGRect,show: Binding<Bool>,currentSpot: Binding<Int>,properties: BoundsKeyProperties,onTap: @escaping ()->())->some View{
        Rectangle()
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .opacity(show.wrappedValue ? 1 : 0)
            // MARK: Spotlight Text
            .overlay(alignment: .topLeading){
                Text(properties.text)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    // MARK: Extracting Text Size
                    .opacity(0)
                    .overlay {
                        GeometryReader{proxy in
                            let textSize = proxy.size
                            
                            Text(properties.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                // MARK: Dynamic Text Alignment
                                // MARK: Horizontal Checking
                                .offset(x: (rect.minX + textSize.width) > (screenSize.width - 15) ? -((rect.minX + textSize.width) - (screenSize.width - 15) ) : 0)
                                // MARK: Vertical Checking
                                .offset(y: (rect.maxY + textSize.height) > (screenSize.height - 50) ? -(textSize.height + (rect.maxY - rect.minY) + 30) : 30)
                        }
                        .offset(x: rect.minX, y: rect.maxY)
                    }
            }
            // MARK: Reverse Masking the Current Spot
            // By Doing this, The Currently Spotlighted View will be Looking like Higlighted
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        let radius = properties.shape == .circle ? (rect.width / 2) : (properties.shape == .rectangle ? 0 : properties.radius)
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.minX, y: rect.minY)
                            .blendMode(.destinationOut)
                    }
            }
            .onTapGesture {
                // MARK: Updating Soptlight Spot
                // If Avaialble
                onTap()
            }
    }
}

// MARK: Spotlight Shape
enum SpotlightShape{
    case circle
    case rectangle
    case rounded
}

// MARK: Bounds Preference Key
struct BoundsKey: PreferenceKey{
    static var defaultValue: [Int: BoundsKeyProperties] = [:]
    
    static func reduce(value: inout [Int : BoundsKeyProperties], nextValue: () -> [Int : BoundsKeyProperties]) {
        value.merge(nextValue()){$1}
    }
}

// MARK: Bounds Preference Key Properties
struct BoundsKeyProperties{
    var shape: SpotlightShape
    var anchor: Anchor<CGRect>
    var text: String = ""
    var radius: CGFloat = 0
}

struct Spotlight_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
