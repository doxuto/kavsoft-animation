//
//  Home.swift
//  TaskAnimation (iOS)
//
//  Created by Balaji on 01/03/22.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var animatedStates: [Bool] = Array(repeating: false, count: 3)
    // Hero Effect
    @Namespace var animation
    // Current Date
    @State var currentDate: Date = Date()
    
    var body: some View {
        ZStack{
            // If we hide the view while its transitioning it will give some opacity change in the view
            // Ignore the warning since the view is anyway going to be removed later
            if !animatedStates[1]{
                RoundedRectangle(cornerRadius: animatedStates[0] ? 30 : 0, style: .continuous)
                    .fill(Color("Purple"))
                    .matchedGeometryEffect(id: "DATEVIEW", in: animation)
                    .ignoresSafeArea()
                
                // Splash Logo
                Image("Logo")
                    .scaleEffect(animatedStates[0] ? 0.25 : 1)
                    .matchedGeometryEffect(id: "SPLASHLOGO", in: animation)
            }
            
            if animatedStates[0]{
                // MARK: Home View
                VStack(spacing: 0){
                    
                    // MARK: Nav Bar
                    Button {
                        
                    } label: {
                     
                        Image(systemName: "rectangle.leadinghalf.inset.filled")
                            .font(.title3)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,alignment: .trailing)
                    .overlay(content: {
                        Text("All debts")
                            .font(.title3)
                            .fontWeight(.semibold)
                    })
                    .padding(.bottom,30)
                    
                    // Custom Calendar
                    // Video in the Description, Check it out
                    CustomDatePicker(currentDate: $currentDate)
                        .padding(.vertical,10)
                        .overlay(alignment: .topLeading, content: {
                            
                            Image("Logo")
                                .scaleEffect(0.25)
                                .matchedGeometryEffect(id: "SPLASHLOGO", in: animation)
                                .offset(x: -10, y: -15)
                        })
                        .background{
                            
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color("Purple"))
                                .matchedGeometryEffect(id: "DATEVIEW", in: animation)
                        }
                    
                    // MARK: Users ScrollView
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 20){
                            
                            ForEach(users){user in
                                // MARK: User Card View
                                UserCardView(user: user, index: getIndex(user: user))
                            }
                        }
                        .padding(.vertical)
                        .padding(.top,30)
                    }
                    // Optional
                    //.opacity(animatedStates[2] ? 1 : 0)
                }
                .padding([.horizontal,.top])
                .frame(maxHeight: .infinity,alignment: .top)
            }
        }
        .onAppear(perform: startAnimations)
    }
    
    func getIndex(user: User)->Int{
        return users.firstIndex { currentUser in
            return user.id == currentUser.id
        } ?? 0
    }
    
    // Animating View
    func startAnimations(){
        
        // MARK: Displaying Splash Icon for Some Time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.7)){
                animatedStates[0] = true
            }
            
            // Removing View after the view is animated
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                animatedStates[1] = true
                withAnimation(.easeInOut(duration: 0.5)){
                    animatedStates[2] = true
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
