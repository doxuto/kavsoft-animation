//
//  Home.swift
//  LiquidIntro (iOS)
//
//  Created by Balaji on 20/10/21.
//

import SwiftUI

struct Home: View {
    
    // Intros....
    @State var intros: [Intro] = [
    
        Intro(title: "Plan", subTitle: "your routes", description: "View your collection route Follow, change or add to your route yourself", pic: "Pic1",color: Color("Green")),
        Intro(title: "Quick Waste", subTitle: "Transfer Note", description: "Record oil collections easily and accurately. No more paper!", pic: "Pic2",color: Color("DarkGrey")),
        Intro(title: "Invite", subTitle: "restaurants", description: "Know some restaurant who want to optimize oil collection? Invite them with one click", pic: "Pic3",color: Color("Yellow")),
    ]
    
    // Gesture Properties...
    @GestureState var isDragging: Bool = false
    
    @State var fakeIndex: Int = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        ZStack{
            
            // Why we using indicies...
            // since the app supports iOS 14
            // as well as were updating offset on real time...
            
            ForEach(intros.indices.reversed(),id: \.self){index in
                
                // Intro View...
                IntroView(intro: intros[index])
                // Custom Liquid Shape....
                    .clipShape(LiquidShape(offset: intros[index].offset, curvePoint: fakeIndex == index ? 50 : 0))
                    .padding(.trailing,fakeIndex == index ? 15 : 0)
                    .ignoresSafeArea()
            }
            
            HStack(spacing: 8){
                
                // Indicator....
                ForEach(0..<intros.count - 2,id: \.self){index in
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentIndex == index ? 1.15 : 0.85)
                        .opacity(currentIndex == index ? 1 : 0.25)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

            }
            .padding()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        // arrow with Drag Gesture...
        .overlay(
        
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .contentShape(Rectangle())
                .gesture(
                
                    // Drag Gesture...
                    DragGesture()
                        .updating($isDragging, body: { value, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            
                            // updating offset...
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)){
                                
                                intros[fakeIndex].offset = isDragging ? value.translation : .zero
                            }
                        })
                        .onEnded({ value in
                            
                            withAnimation(.spring()){
                                
                                // checking....
                                if -intros[fakeIndex].offset.width > getRect().width / 2{
                                    
                                    // setting width to height...
                                    intros[fakeIndex].offset.width = -getRect().height * 1.5
                                    
                                    // Updating Index...
                                    fakeIndex += 1
                                    
                                    // Updating Orignal index...
                                    if currentIndex == intros.count - 3{
                                        currentIndex = 0
                                    }
                                    else{
                                        currentIndex += 1
                                    }
                                    
                                    // when fake index reaches the element that is before last one
                                    // shifting again to first last so that it will create a feel like infinite carousel...
                                    
                                    // some delay to finish the swipe aniamtion...
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        
                                        if fakeIndex == (intros.count - 2){
                                            
                                            for index in 0..<intros.count - 2{
                                                intros[index].offset = .zero
                                            }
                                            
                                            // updating current index...
                                            fakeIndex = 0
                                        }
                                    }
                                }
                                else{
                                 
                                    intros[fakeIndex].offset = .zero
                                }
                            }
                        })
                )
                .ignoresSafeArea()
                .offset(y: (80 + 25) - getSafeArea().top)
                .opacity(isDragging ? 0 : 1)
                .animation(.linear, value: isDragging)
                
            
            ,alignment: .topTrailing
        )
        .onAppear {
            
            // Inserting last element to first
            // and first to last to create a feel like infinite carousel...
            
            guard let first = intros.first else{
                return
            }
            
            guard var last = intros.last else{
                return
            }
            
            last.offset.width = -getRect().height * 1.5
            
            intros.append(first)
            intros.insert(last, at: 0)
            
            // updating fake index...
            fakeIndex = 1
        }
    }
    
    @ViewBuilder
    func IntroView(intro: Intro)->some View{
        
        VStack{
            
            Image(intro.pic)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(40)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(intro.title)
                    .font(.system(size: 45))
                
                Text(intro.subTitle)
                    .font(.system(size: 50, weight: .bold))
                
                Text(intro.description)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.top)
                    .frame(width: getRect().width - 100)
                    .lineSpacing(8)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.leading,20)
            .padding([.trailing,.top])
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
        
            intro.color
        )
    }
}

// Extending View to get Screen Bounds...
extension View{
    
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// For more on Liquid Swipe see my Liquid Swipe Video...
// Link in description...

struct LiquidShape: Shape{
    
    var offset: CGSize
    var curvePoint: CGFloat
    
    // Multiple Animatable Data...
    // Animating Shapes...
    var animatableData: AnimatablePair<CGSize.AnimatableData,CGFloat>{
        get{
            return AnimatablePair(offset.animatableData,curvePoint)
        }
        set{
            offset.animatableData = newValue.first
            curvePoint = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            // when user moves left...
            // increasing size both in top and bottom....
            // so it will create a liquid swipe effect...
            
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            // First Constructing Rectangle Shape...
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            // Now Constructing Curve Shape....
            
            // from
            let from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            // Also Adding Height...
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
            
            // Mid Between 80 - 180.....
            let mid : CGFloat = 80 + ((to - 80) / 2)

            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - curvePoint, y: mid), control2: CGPoint(x: width - curvePoint, y: mid))
        }
    }
}
