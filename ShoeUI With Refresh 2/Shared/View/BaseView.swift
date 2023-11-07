//
//  BaseView.swift
//  BaseView
//
//  Created by Balaji on 31/08/21.
//

import SwiftUI

struct BaseView: View {
    @StateObject var baseData = BaseViewModel()
    
    // Hiding Tab bar...
    init(){
    
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        TabView(selection: $baseData.currentTab) {
            
            Home()
                .environmentObject(baseData)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.04))
                .tag(Tab.Home)
            
            Text("heart")
                .tag(Tab.Heart)
            
            Text("Clipboard")
                .tag(Tab.ClipBoard)
            
            Text("Person")
                .tag(Tab.Person)
        }
        .overlay(
        
            // Custom Tab Bar...
            HStack(spacing: 0){
                // tabButton...
                TabButton(Tab: .Home)
                
                TabButton(Tab: .Heart)
                    .offset(x: -10)
                
                // Center Curved Button...
                Button {
                    
                } label: {
                    Image("cart")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                        .offset(x: -1)
                        .padding(18)
                        .background(Color("DarkBlue"))
                        .clipShape(Circle())
                    // shadows..
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
                }
                .offset(y: -30)

                
                TabButton(Tab: .ClipBoard)
                    .offset(x: 10)
                
                TabButton(Tab: .Person)
            }
            .background(
                Color.white
                    .clipShape(CustomCurveShape())
                // shadow...
                .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                    .ignoresSafeArea(.container, edges: .bottom)
            )
            // hiding tab bar when detail opens...
            .offset(y: baseData.showDetail ? 200 : 0)
            
            ,alignment: .bottom
        )
    }
    
    @ViewBuilder
    func TabButton(Tab: Tab)-> some View{
        
        Button {
            withAnimation{
                baseData.currentTab = Tab
            }
        } label: {
         
            Image(Tab.rawValue)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(baseData.currentTab == Tab ? Color("DarkBlue") : Color.gray.opacity(0.5))
                .frame(maxWidth: .infinity)
        }

    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
