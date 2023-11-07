//
//  MorphingView.swift
//  Morphing
//
//  Created by Balaji on 18/09/22.
//

import SwiftUI

struct MorphingView: View {
    // MARK: View Properties
    @State var currentImage: CustomShape = .cloud
    @State var pickerImage: CustomShape = .cloud
    @State var turnOffImageMorph: Bool = false
    @State var blurRadius: CGFloat = 0
    @State var animateMorph: Bool = false
    var body: some View {
        VStack{
            // MARK: Image Morph is Simple
            // Simply Mask the Canvas Shape as Image Mask
            GeometryReader{proxy in
                let size = proxy.size
                Image("iJustine")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(x: -20, y: 40)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .overlay(content: {
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImageMorph ? 1 : 0)
                    })
                    .mask {
                        // MARK: Morphing Shapes With the Help of Canvas and Filters
                        Canvas{context,size in
                            // MARK: Morphing Filters
                            // For More Morph Shape Link
                            // MARK: For More Morph Shape Link Change This
                            context.addFilter(.alphaThreshold(min: 0.4))
                            // MARK: This Value Plays Major Role in the Morphing Animation
                            // MARK: For Reverse Animation
                            // Until 20 -> It will be like 0-1
                            // After 20 Till 40 -> It will be like 1-0
                            context.addFilter(.blur(radius: blurRadius >= 20 ? 20 - (blurRadius - 20) : blurRadius))
                            
                            // MARK: Draw Inside Layer
                            context.drawLayer { ctx in
                                if let resolvedImage = context.resolveSymbol(id: 1){
                                    ctx.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2),anchor: .center)
                                }
                            }
                        } symbols: {
                            // MARK: Giving Images With ID
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        // MARK: Animations will not Work in the Canvas
                        // We can use Timeline View For those Animations
                        // But here I'm going to simply Use Timer to Acheive the Same Effect
                        
                        // The Timer Value is Animation Speed
                        // You can Change this for your Own
                        // EG: For Optimal Speed Use = 0.007
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                            if animateMorph{
                                if blurRadius <= 40{
                                    blurRadius += 0.5
                                    
                                    if blurRadius.rounded() == 20{
                                        // MARK: Change Of Next Image Goes Here
                                        currentImage = pickerImage
                                    }
                                }
                                
                                if blurRadius.rounded() == 40{
                                    // MARK: End Animation And Reset the Blur Radius to Zero
                                    animateMorph = false
                                    blurRadius = 0
                                }
                            }
                        }
                    }
            }
            .frame(height: 400)
            
            // MARK: Segmented Picker
            Picker("", selection: $pickerImage) {
                ForEach(CustomShape.allCases,id: \.rawValue){shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .pickerStyle(.segmented)
            // MARK: Avoid Tap Until The Current Animation is Finished
            .overlay(content: {
                Rectangle()
                    .fill(.primary)
                    .opacity(animateMorph ? 0.05 : 0)
            })
            .padding(15)
            .padding(.top,-50)
            // MARK: When Ever Picker Image Changes
            // Morphing Into New Shape
            .onChange(of: pickerImage) { newValue in
                animateMorph = true
            }
            
            Toggle("Turn Off Image Morph", isOn: $turnOffImageMorph)
                .fontWeight(.semibold)
                .padding(.horizontal,15)
                .padding(.top,10)
        }
        .offset(y: -50)
        .frame(maxHeight: .infinity,alignment: .top)
    }
}

struct ResolvedImage: View{
    @Binding var currentImage: CustomShape
    var body: some View{
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
            .frame(width: 300, height: 300)
    }
}

struct MorphingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
