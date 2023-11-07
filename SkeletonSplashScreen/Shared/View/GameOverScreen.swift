//
//  GameOverScreen.swift
//  SkeletonSplashScreen (iOS)
//
//  Created by Balaji on 19/02/22.
//

import SwiftUI

struct GameOverScreen: View {
    
    // MARK: Animation Properties
    // There are total 10 Images
    // Why 11 Since Our first image starts at 1 so Extra 1
    @State var startOffsets: [CGSize] = Array(repeating: CGSize(width: 0, height: -UIScreen.main.bounds.height), count: 11)
    
    @State var skeletonRotation: [Angle] = Array(repeating: .init(degrees: 0), count: 11)
    
    @State var rotatedOffsets: [CGSize] = Array(repeating: .zero, count: 11)
    
    // Blink Animation
    @State var startTextBlink: Bool = false
    
    var body: some View {
        ZStack{
            
            Color.black
            
            // MARK: Building Skeleton With Individual Images
            VStack {
                VStack{
                    
                    Image("Skeleton_1")
                        .renderingMode(.template)
                        .offset(startOffsets[1])
                        .rotationEffect(skeletonRotation[1])
                        .offset(rotatedOffsets[1])
                    
                    Image("Skeleton_2")
                        .renderingMode(.template)
                        .offset(startOffsets[2])
                        .rotationEffect(skeletonRotation[2])
                        .offset(rotatedOffsets[2])
                    // MARK: Hands
                        .overlay(alignment: .top) {
                            HStack{
                                
                                Image("Skeleton_6")
                                    .renderingMode(.template)
                                    .offset(startOffsets[6])
                                    .offset(rotatedOffsets[6])
                                    .rotationEffect(skeletonRotation[6])
                                
                                Spacer()
                                
                                VStack{
                                    Image("Skeleton_7")
                                        .renderingMode(.template)
                                        .offset(startOffsets[7])
                                        .rotationEffect(skeletonRotation[7])
                                        .offset(rotatedOffsets[7])
                                    
                                    Image("Skeleton_8")
                                        .renderingMode(.template)
                                        .padding(.top,-25)
                                        .offset(x: 10)
                                        .offset(startOffsets[8])
                                        .rotationEffect(skeletonRotation[8])
                                        .offset(rotatedOffsets[8])
                                }
                            }
                            .padding(.horizontal,-40)
                        }
                    
                    Image("Skeleton_3")
                        .renderingMode(.template)
                        .offset(y: -8)
                        .offset(startOffsets[3])
                        .rotationEffect(skeletonRotation[3])
                        .offset(rotatedOffsets[3])
                    // MARK: Legs
                        .overlay(alignment: .bottom){
                            HStack{
                                
                                VStack{
                                    Image("Skeleton_4")
                                        .renderingMode(.template)
                                        .offset(startOffsets[4])
                                        .rotationEffect(skeletonRotation[4])
                                        .offset(rotatedOffsets[4])
                                    
                                    Image("Skeleton_9")
                                        .renderingMode(.template)
                                        .padding(.top,-30)
                                        .offset(startOffsets[9])
                                        .rotationEffect(skeletonRotation[9])
                                        .offset(rotatedOffsets[9])
                                }
                                .offset(x: -15,y: -8)
                                
                                Spacer()
                                
                                VStack{
                                    Image("Skeleton_5")
                                        .renderingMode(.template)
                                        .offset(startOffsets[5])
                                        .rotationEffect(skeletonRotation[5])
                                        .offset(rotatedOffsets[5])
                                    
                                    Image("Skeleton_10")
                                        .renderingMode(.template)
                                        .padding(.top,-30)
                                        .offset(startOffsets[10])
                                        .rotationEffect(skeletonRotation[10])
                                        .offset(rotatedOffsets[10])
                                }
                                .offset(x: 20,y: -8)
                            }
                            .offset(y: 160)
                        }
                }
                .foregroundColor(.white)
                // Applying Scaling Effect
                // When last Rotated Offset is set
                .scaleEffect(rotatedOffsets[1].width == 0 ? 1 : 0.8)
                .offset(x: -10)
                
                // Game Over Text
                if rotatedOffsets[1].width != 0{
                    Text("GAME\nOVER")
                        .font(.custom("Game Over", size: 175))
                        .foregroundColor(.white)
                        .padding(.top,110)
                        .opacity(startTextBlink ? 1 : 0)
                }
            }
            // Making it Center
            .padding(.bottom,rotatedOffsets[1].width == 0 ? 160 : 0)
        }
        .ignoresSafeArea()
        .onAppear(perform: intiateAnimation)
    }
    
    func intiateAnimation(){
        (1...10).forEach { index in
            // Delay for each Image
            withAnimation(.easeInOut(duration: 0.3).delay(Double(index) / 40)){
                // Bottom to top
                startOffsets[11 - index] = .zero
            }
        }
        
        (1...10).forEach { index in
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6).delay(0.7).speed(1.2)){
                
                skeletonRotation[index] = .init(degrees: rotations[index - 1])
                self.rotatedOffsets[index] = rotatedOffsets_[index - 1]
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)){
                startTextBlink.toggle()
            }
        }
    }
}

struct GameOverScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 8")
    }
}

// MARK: Dab Skeleton Rotation Values
let rotations: [Double] = [-23,-17,-7,27,-21,-105,-82,-110,10,-4]
// After Rotation Offset Values will be Changed
// Those Values are
let rotatedOffsets_: [CGSize] = [

    CGSize(width: -35, height: 12),
    CGSize(width: -6,height: 0),
    CGSize(width: 12, height: 0),
    CGSize(width: 0, height: 0),
    CGSize(width: 25, height: 0),
    CGSize(width: 55, height: 80),
    CGSize(width: 5, height: -60),
    CGSize(width: 102, height: -172),
    CGSize(width: -25, height: 0),
    CGSize(width: 45, height: 0),
]
