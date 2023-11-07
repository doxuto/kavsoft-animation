//
//  MainView.swift
//  PlantApp
//
//  Created by Balaji on 13/10/22.
//

import SwiftUI

struct MainView: View {
    // MARK: View Properties
    @State var currentTab: Tab = .home
    @Namespace var animation
    init(){
        // MARK: For Hiding Native Tab Bar
        // As of Xcode 14.1 Beta .toolbar(.hidden) is broken for Native SwiftUI TabView
        UITabBar.appearance().isHidden = true
    }
    @State var showTabBar: Bool = true
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                Home()
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.home)
                
                Text("Scan")
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.scan)
                
                Text("File's")
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.folder)
                
                Text("Cart")
                    .setTabBarBackground(color: Color("BG"))
                    .tag(Tab.cart)
            }
            
            TabBar()
                .offset(y: showTabBar ? 0 : 130)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: showTabBar)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Instead Of Passing Reference We're Going to Use NotificationCenter to Post Notification
        .onReceive(NotificationCenter.default.publisher(for: .init("SHOWTABBAR"))) { _ in
            showTabBar = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("HIDETABBAR"))) { _ in
            showTabBar = false
        }
    }
    
    // MARK: Custom Tab Bar
    @ViewBuilder
    func TabBar()->some View{
        HStack(spacing: 0){
            ForEach(Tab.allCases,id: \.rawValue){tab in
                Image(tab.rawValue)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.5))
                    .offset(y: currentTab == tab ? -30 : 0)
                    .background(content: {
                        if currentTab == tab{
                            Circle()
                                .fill(.black)
                                .scaleEffect(2.5)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 5, y: 10)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                                .offset(y: currentTab == tab ? -30 : 0)
                        }
                    })
                    .frame(maxWidth: .infinity)
                    .padding(.top,15)
                    .padding(.bottom,10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        currentTab = tab
                    }
            }
        }
        .padding(.horizontal,15)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.65), value: currentTab)
        .background {
            // MARK: Custom Corner
            CustomCorner(corners: [.topLeft,.topRight], radius: 25)
                .fill(Color("Tab"))
                .ignoresSafeArea()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Extension for Setting Tab View Background
extension View{
    // Global View Access For Show/Hide Tab Bar
    func showTabBar(){
        NotificationCenter.default.post(name: NSNotification.Name("SHOWTABBAR"), object: nil)
    }
    
    func hideTabBar(){
        NotificationCenter.default.post(name: NSNotification.Name("HIDETABBAR"), object: nil)
    }
    
    @ViewBuilder
    func setTabBarBackground(color: Color)->some View{
        self
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background {
                color
                    .ignoresSafeArea()
            }
    }
}
