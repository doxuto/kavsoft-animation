//
//  Home.swift
//  Scrollable Menu (iOS)
//
//  Created by Balaji on 23/10/21.
//

import SwiftUI

struct Home: View {
    
    // Current Tab...
    @State var currentTab = ""
    @Namespace var animation
    
    @State var onTapCurrentTab: String = ""
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        VStack(spacing: 0){
            
            VStack{
                
                HStack(spacing: 15){
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }

                    Text("McDonalds's - Chinatown")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                
                // SCroll View Reader...
                // to scroll tab automatically when user scrolls...
                
                ScrollViewReader{proxy in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 30){
                            
                            ForEach(tabsItems){tab in
                                
                                VStack{
                                    
                                    Text(tab.tab)
                                        .foregroundColor(currentTab == tab.id ? .black : .gray)
                                        .animation(.none, value: currentTab)
                                    
                                    // For matched geometry effect...
                                    if currentTab == tab.id{
                                        
                                        Capsule()
                                            .fill(.black)
                                            .matchedGeometryEffect(id: "TAB", in: animation)
                                            .frame(height: 3)
                                            .padding(.horizontal,-10)
                                    }
                                    else{
                                        
                                        Capsule()
                                            .fill(.clear)
                                            .frame(height: 3)
                                            .padding(.horizontal,-10)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {

                                    if onTapCurrentTab == tab.id{return}
                                    
                                    withAnimation(.easeInOut){
                                        onTapCurrentTab = tab.id
                                        proxy.scrollTo(tab.id, anchor: .topTrailing)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal,30)
                        .onChange(of: currentTab) { _ in
                            
                            withAnimation{
                                proxy.scrollTo(currentTab, anchor: .topTrailing)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .padding([.top])
            // Divider...
            .background(scheme == .dark ? Color.black : Color.white)
            .overlay(
                Divider()
                    .padding(.horizontal,-15)
                
                ,alignment: .bottom
            )
            
            ScrollView(.vertical,showsIndicators: false){
                
                // Scroll view reader to scroll the content...
                ScrollViewReader{proxy in
                    
                    VStack(spacing: 15){
                        
                        ForEach(tabsItems){tab in
                            
                            // Menu Card View...
                            MenuCardView(tab: tab,currentTab: $currentTab)
                                .padding(.top)
                        }
                    }
                    .padding([.horizontal,.bottom])
                    .onChange(of: onTapCurrentTab) { newValue in
                        
                        // Scrolling to content...
                        withAnimation(.easeInOut){
                            proxy.scrollTo(onTapCurrentTab, anchor: .topTrailing)
                        }
                    }
                }
            }
            // Setting Coordinate Space name for offset..
            .coordinateSpace(name: "SCROLL")
        }
        // Setting first tab...
        .onAppear {
            currentTab = tabsItems.first?.id ?? ""
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct MenuCardView: View{
    
    var tab: Tab
    @Binding var currentTab: String
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text(tab.tab)
                .font(.title.bold())
                .padding(.vertical)
            
            ForEach(tab.foods){food in
                
                // Food View...
                HStack(spacing: 15){
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(food.title)
                            .font(.title3.bold())
                        
                        Text(food.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("Price: \(food.price)")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Image(food.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                }
                
                Divider()
            }
        }
        .modifier(OffsetModifier(tab: tab, currentTab: $currentTab))
        // setting ID for Scroll View Reader...
        .id(tab.id)
    }
}
