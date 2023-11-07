//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Balaji on 09/09/21.
//

import SwiftUI

// MARK: See My Material Curved Tab Bar Video
// Link In Bio
// MARK: Modifying For Our Usage

struct CustomTabBar: View {
    @Binding var currentTab: Tab
    var animation: Namespace.ID
    // Current Tab XValue...
    @State var currentXValue: CGFloat = 0
    var body: some View {
        HStack(spacing: 0){
            ForEach(Tab.allCases,id: \.rawValue){tab in
                TabButton(tab: tab)
                    .overlay {
                        Text(tab.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("Black"))
                            .offset(y: currentTab == tab ? 15 : 100)
                    }
            }
        }
        .padding(.top)
        // Preview wont show safeArea...
        .padding(.bottom,getSafeArea().bottom == 0 ? 15 : 10)
        .background{
            Color.white
                .shadow(color: Color("Black").opacity(0.08), radius: 5, x: 0, y: -5)
                .clipShape(BottomCurve(currentXValue: currentXValue))
                .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    // TabButton...
    @ViewBuilder
    func TabButton(tab: Tab)->some View{
        // Since we need XAxis Value for Curve...
        GeometryReader{proxy in
            Button {
                withAnimation(.easeInOut){
                    currentTab = tab
                    // updating Value...
                    currentXValue = proxy.frame(in: .global).midX
                }
                
            } label: {
                // Moving Button up for current Tab...
                Image(tab.rawValue)
                // Since we need perfect value for Curve...
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.8))
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack{
                            if currentTab == tab{
                                Circle()
                                    .fill(Color("Orange"))
                                    .shadow(color: Color("Black").opacity(0.1), radius: 8, x: 5, y: 5)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            // Setting intial Curve Position...
            .onAppear {
                
                if tab == Tab.allCases.first && currentXValue == 0{
                    
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
    }
}

// MARK: Tabs
enum Tab: String,CaseIterable{
    case home = "Home"
    case cart = "Cart"
    case favourite = "Star"
    case profile = "Profile"
}

// Getting Safe Area...
extension View{
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
