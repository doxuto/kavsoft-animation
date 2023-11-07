//
//  Home.swift
//  AnimationsTutorial (iOS)
//
//  Created by Balaji on 20/01/22.
//

import SwiftUI

struct Home: View {
    // MARK: Sample Colors
    @State var colors: [ColorGrid] = [
        
        ColorGrid(hexValue: "#15654B", color: Color("Green")),
        ColorGrid(hexValue: "#DAA4FF", color: Color("Violet")),
        ColorGrid(hexValue: "#FFD90A", color: Color("Yellow")),
        ColorGrid(hexValue: "#FE9EC4", color: Color("Pink")),
        ColorGrid(hexValue: "#FB3272", color: Color("Orange")),
        ColorGrid(hexValue: "#4460EE", color: Color("Blue")),
    ]
    
    // MARK: Animation Properties
    // Instead of making each boolean for separate animation making it as a array to avoid multiple lines of code.
    @State var animations: [Bool] = Array(repeating: false, count: 10)
    
    // MatchedGeometry Namespace
    @Namespace var animation
    
    // Card Color
    @State var selectedColor: Color = Color("Pink")
    var body: some View {
        
        VStack{
            
            HStack{
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .hLeading()

                Button {
                    
                } label: {

                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
            }
            .padding([.horizontal,.top])
            .padding(.bottom,5)
            
            // MARK: Using Geometry Reader for Setting Offset
            GeometryReader{proxy in
                
                let maxY = proxy.frame(in: .global).maxY
                
                CreditCard()
                // MARK: 3D Rotation
                    .rotation3DEffect(.init(degrees: animations[0] ? 0 : -270), axis: (x: 1, y: 0, z: 0), anchor: .center)
                    .offset(y: animations[0] ? 0 : -maxY)
                
            }
            .frame(height: 250)
            
            HStack{
                
                Text("Choose a color")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .hLeading()
                    .offset(x: animations[1] ? 0 : -200)
                
                Button {
                    
                } label: {
                    Text("View all")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Pink"))
                        .underline()
                }
                .offset(x: animations[1] ? 0 : 200)
            }
            .padding()
            
            GeometryReader{proxy in
                                
                ZStack{
                    
                    Color.black
                        .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 40))
                        .frame(height: animations[2] ? nil : 0)
                        .vBottom()
                    
                    ZStack{
                        
                        // MARK: Intial Grid View
                        ForEach(colors){colorGrid in
                            
                            // Hiding the source Onces
                            if !colorGrid.removeFromView{
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorGrid.color)
                                    .matchedGeometryEffect(id: colorGrid.id, in: animation)
                                    .frame(width: 150, height: animations[3] ? 60 : 150)
                                // MARK: Rotating Cards
                                    .rotationEffect(.init(degrees: colorGrid.rotateCards ? 180 : 0))
                            }
                        }
                    }
                    // MARK: Applying Opacity with Scale Animation
                    // To Avoid this Creating a BG OVerlay and hiding it
                    // So that it will look like the whole stack is Applying Opacity Animation
                    .overlay(
                    
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("BG"))
                            .frame(width: 150, height: animations[3] ? 60 : 150)
                            .opacity(animations[3] ? 0 : 1)
                    )
                    // Scale Effect
                    .scaleEffect(animations[3] ? 1 : 2.3)
                }
                .hCenter()
                .VCenter()
                .clipped()
                
                // MARK: ScrollView with Color Grids
                ScrollView(.vertical, showsIndicators: false) {
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        ForEach(colors){colorGrid in
                            
                            GridCardView(colorGrid: colorGrid)
                        }
                    }
                    .padding(.top,40)
                }
                .cornerRadius(40)
            }
            .padding(.top)
        }
        .vTop()
        .hCenter()
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color("BG"))
        .preferredColorScheme(.dark)
        .onAppear(perform: animateScreen)
    }
    
    // MARK: Grid Card View
    @ViewBuilder
    func GridCardView(colorGrid: ColorGrid)->some View{
        
        VStack{
            
            if colorGrid.addToGrid{
                
                // Displaying With Matched Geometry Effect
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorGrid.color)
                    .frame(width: 150, height: 60)
                    .matchedGeometryEffect(id: colorGrid.id, in: animation)
                // When Animated Grid Card is Displayed Displaying the Color Text
                    .onAppear {
                        if let index = colors.firstIndex(where: { color in
                            return color.id == colorGrid.id
                        }){
                            withAnimation{
                                colors[index].showText = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                withAnimation{
                                    colors[index].removeFromView = true
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation{
                            selectedColor = colorGrid.color
                        }
                    }
            }
            else{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .frame(width: 150, height: 60)
            }
            
            Text(colorGrid.hexValue)
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.white)
                .hLeading()
                .padding([.horizontal,.top])
                .opacity(colorGrid.showText ? 1 : 0)
        }
    }
    
    func animateScreen(){
        
        // MARK: Animating Screen
        // First Animation of Credit Card
        // Delaying First Animation after the second Animation
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7).delay(0.2)){
            animations[0] = true
        }
        
        // Second Animating the Hstack with View All Button
        withAnimation(.easeInOut(duration: 0.7)){
            animations[1] = true
        }
        
        // Third Animation Making The Bottom to Slide up eventually
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7).delay(0.2)){
            animations[2] = true
        }
        
        // Third Animation Applying Opacity with scale animation for Stack Grid Colors
        withAnimation(.easeInOut(duration: 0.8)){
            animations[3] = true
        }
        
        // Final Grid Forming Animation
        for index in colors.indices{
            
            // Animating after the opacity animation has Finished its job
            // Rotating One card another with a time delay of 0.1sec
            let delay: Double = (0.9 + (Double(index) * 0.1))
            
            // Last card is rotating first since we're putting in ZStack
            // To avoid this recalulate index from back
            let backIndex = ((colors.count - 1) - index)
            
            withAnimation(.easeInOut.delay(delay)){
                colors[backIndex].rotateCards = true
            }
            
            // After rotation adding it to grid view one after anothre
            // Since .delay() will not work on if...else
            // So using DispathcQueue delay
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation{
                    colors[backIndex].addToGrid = true
                }
            }
        }
    }
    
    // MARK: Animated Credit Card
    @ViewBuilder
    func CreditCard()->some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedColor)
            
            VStack{
                
                HStack{
                    ForEach(1...4,id: \.self){_ in
                        Circle()
                            .fill(.white)
                            .frame(width: 6, height: 6)
                    }
                    
                    Text("7864")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .hLeading()
                
                HStack(spacing: -12){
                    
                    Text("Jenna Ezarik")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .hLeading()
                    
                    Circle()
                        .stroke(.white,lineWidth: 1)
                        .frame(width: 30, height: 30)
                    
                    Circle()
                        .stroke(.white,lineWidth: 1)
                        .frame(width: 30, height: 30)
                }
                .vBottom()
            }
            .padding(.vertical,20)
            .padding(.horizontal)
            .vTop()
            .hLeading()
            
            // MARK: Top Ring
            Circle()
                .stroke(Color.white.opacity(0.5),lineWidth: 18)
                .offset(x: 130, y: -120)
        }
        .clipped()
        .padding()
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Extensions for Making UI Design Faster
extension View{
    
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func hTrailing()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .trailing)
    }
    
    func hCenter()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .center)
    }
    
    func VCenter()->some View{
        self
            .frame(maxHeight: .infinity,alignment: .center)
    }
    
    func vTop()->some View{
        self
            .frame(maxHeight: .infinity,alignment: .top)
    }
    
    func vBottom()->some View{
        self
            .frame(maxHeight: .infinity,alignment: .bottom)
    }
}
