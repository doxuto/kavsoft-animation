//
//  OnBoarding.swift
//  OnBoarding
//
//  Created by Balaji on 27/08/21.
//

import SwiftUI

struct OnBoarding: View {
    @State var offset: CGFloat = 0
    @State var showLight: Bool = true
    @State var currentHightlight: Int = 0
    var body: some View {
        
        // Custom Pager View...
        OffsetPageTabView(offset: $offset) {
            
            HStack(spacing: 0){
                
                ForEach(boardingScreens){screen in
                    
                    VStack(spacing: 15){
                        
                        Image(screen.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
                        // small screen Adoption...
                            .scaleEffect(getScreenBounds().height < 750 ? 0.9 : 1)
                            .offset(y: getScreenBounds().height < 750 ? -100 : -120)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text(screen.title)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding(.top,20)
                            
                            Text(screen.description)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .offset(y: -70)
                    }
                    .padding()
                    .frame(width: getScreenBounds().width)
                    .frame(maxHeight: .infinity)
                }
            }
        }
        // Animation...
        .background(
        
            RoundedRectangle(cornerRadius: 50)
                .fill(.white)
            // Size as image size...
                .frame(width: getScreenBounds().width - 100,height: getScreenBounds().width - 100)
                .scaleEffect(2)
                .rotationEffect(.init(degrees: 25))
                .rotationEffect(.init(degrees: getRotation()))
                .offset(y: -getScreenBounds().width + 20)
            
            ,alignment: .leading
        )
        .background(
            Color("screen\(getIndex() + 1)")
                .animation(.easeInOut, value: getIndex())
        )
        // animating...
        .ignoresSafeArea(.container, edges: .all)
        .overlay(
        
            VStack{
                
                // Bottom Content...
                HStack(spacing: 25){
                    
                    Button {
                        
                    } label: {
                        Text("Login as iJustine")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.vertical,20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white,in: RoundedRectangle(cornerRadius: 12))
                    }
                    // MARK: Adding Spotlight View
                    .spotlight(enabled: currentHightlight == 1, title: "Login into Account")
                    
                    Button {
                        
                    } label: {
                        Text("SignUp")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .offset(x: -5)
                            .padding(.vertical,20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white,in: RoundedRectangle(cornerRadius: 12))
                    }
                    .spotlight(enabled: currentHightlight == 2, title: "Signup New Account")

                }
                
                HStack{
                    
                    Button {
                        
                    } label: {
                        Text("Skip")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .spotlight(enabled: currentHightlight == 3, title: "Skip Intro's")
                    
                    // Indicators...
                    HStack(spacing: 8){
                        ForEach(boardingScreens.indices,id: \.self){index in
                            Circle()
                                .fill(.white)
                                .opacity(index == getIndex() ? 1 : 0.4)
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == (getIndex()) ? 1.3 : 0.85)
                                .animation(.easeInOut, value: getIndex())
                        }
                    }
                    .spotlight(enabled: currentHightlight == 4, title: "Indicator's")
                    .frame(maxWidth: .infinity)

                    Button {
                        // Setting Mac Offset...
                        // max 4 screens so max will be 3*width....
                        offset = min(offset + getScreenBounds().width,getScreenBounds().width * 3)
                    } label: {
                        Text("Next")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .spotlight(enabled: currentHightlight == 5, title: "Next Intro")

                }
                .padding(.top,30)
                .padding(.horizontal,8)
            }
            .padding()
                
            
            ,alignment: .bottom
        )
        .onTapGesture {
            currentHightlight += 1
        }
    }
    
    // getting Rotation...
    func getRotation()->Double{
        
        let progress = offset / (getScreenBounds().width * 4)
        
        // Doing one full rotation...
        let rotation = Double(progress) * 360
        
        return rotation
    }
    
    // Changing BG Color based on offset...
    func getIndex()->Int{
        let progress = (offset / getScreenBounds().width).rounded()
        
        return Int(progress)
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}

// Extending View to get Screen Bounds...
extension View{
    func getScreenBounds()->CGRect{
        return UIScreen.main.bounds
    }
}
