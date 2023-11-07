//
//  MainView.swift
//  ResponsiveUI2 (iOS)
//
//  Created by Balaji on 03/06/22.
//

import SwiftUI

struct MainView: View {
    // MARK: Current Tab
    @State var currentTab: Tab = .dashboard
    @State var showSideBar: Bool = false
    var body: some View {
        ResponsiveView { props in
            HStack(spacing: 0){
                // MARK: Side Bar
                // MARK: Displaying Only For iPad and Not on Split Mode
                if props.isiPad && !props.isSplit{
                    SideBar(props: props,currentTab: $currentTab)
                }
                
                DashBoard(props: props,showSideBar: $showSideBar)
            }
            .overlay {
                ZStack(alignment: .leading) {
                    Color.black
                        .opacity(showSideBar ? 0.35 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut){showSideBar = false}
                        }
                    
                    if showSideBar{
                        SideBar(props: props, currentTab: $currentTab)
                            .transition(.move(edge: .leading))
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
