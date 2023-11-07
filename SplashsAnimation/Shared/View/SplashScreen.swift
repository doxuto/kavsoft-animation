//
//  SplashScreen.swift
//  SplashsAnimation (iOS)
//
//  Created by Balaji on 17/10/21.
//

import SwiftUI

struct SplashScreen: View {
    
    // Animation Properties...
    @State var startAnimation: Bool = false
    
    @State var circleAnimation1: Bool = false
    @State var circleAnimation2: Bool = false
    
    // End
    @Binding var endAnimation: Bool
    
    var body: some View {
        
        ZStack{
            
            Color("SplashColor")
            
            Group{
                
                // Custom Shape With Animation....
                SplashShape()
                // trimming...
                    .trim(from: 0, to: startAnimation ? 1 : 0)
                // stroke to get outline...
                    .stroke(Color.white,style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                
                // Two Circles...
                Circle()
                    .fill(.white)
                    .frame(width: 35, height: 35)
                    .scaleEffect(circleAnimation1 ? 1 : 0)
                    .offset(x: -80, y: 22)
                
                Circle()
                    .fill(.white)
                    .frame(width: 35, height: 35)
                    .scaleEffect(circleAnimation2 ? 1 : 0)
                    .offset(x: 80, y: -22)
            }
            // Default Frame...
            .frame(width: 220, height: 130)
            .scaleEffect(endAnimation ? 0.15 : 0.9)
            .rotationEffect(.init(degrees: endAnimation ? 85 : 0))
            
            // Bottom Ta Line...
            VStack{
                
                Text("Powered by")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text("Kavsoft")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(maxHeight: .infinity,alignment: .bottom)
            .foregroundColor(Color.white.opacity(0.8))
            .padding(.bottom,getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
            .opacity(startAnimation ? 1 : 0)
            .opacity(endAnimation ? 0 : 1)
        }
        // Moving View Up....
        .offset(y: endAnimation ? -(getRect().height * 1.5) : 0)
        .ignoresSafeArea()
        .onAppear {
            
            // Delay Start...
            withAnimation(.spring().delay(0.15)){
                // First Circle...
                circleAnimation1.toggle()
            }
            
            // Next Shape..
            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1.05, blendDuration: 1.05).delay(0.4)){
                
                startAnimation.toggle()
            }
            
            // Final scnd Circle...
            withAnimation(.spring().delay(0.7)){
                circleAnimation2.toggle()
            }
            
            withAnimation(.easeInOut(duration: 0.65).delay(1.1)){
                
                endAnimation = true
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extending View to get Screen Frame...
extension View{
    
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    // SafeArea...
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

struct SplashShape: Shape{
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            let mid = rect.width / 2
            let height = rect.height
            
            // 80 = 40: Arc Radius...
            path.move(to: CGPoint(x: mid - 80, y: height))
            
            path.addArc(center: CGPoint(x: mid - 40, y: height), radius: 40, startAngle: .init(degrees: 180), endAngle: .zero, clockwise: true)
            
            // straight line...
            path.move(to: CGPoint(x: mid, y: height))
            path.addLine(to: CGPoint(x: mid, y: 0))
            
            // another arc...
            
            path.addArc(center: CGPoint(x: mid + 40, y: 0), radius: 40, startAngle: .init(degrees: -180), endAngle: .zero, clockwise: false)
        }
    }
}
