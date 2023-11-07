//
//  Home.swift
//  AutoScrollingTab
//
//  Created by Balaji on 12/03/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var activeTab: Tab = .men
    @State private var scrollProgress: CGFloat = .zero
    @State private var tapState: AnimationState = .init()
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                TabView(selection: $activeTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        TabImageView(tab)
                            .tag(tab)
                            .offsetX(activeTab == tab) { rect in
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(tab.index))
                                /// Converting Page Offset into Progress
                                let pageProgress = pageOffset / size.width
                                /// Limiting Progress
                                /// Simply Disable When the TapState value is True
                                if !tapState.status {
                                    scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
                                }
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .overlay(alignment: .top, content: {
                TabIndicatorView()
            })
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    /// Tab Indicator View
    @ViewBuilder
    func TabIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            /// We're going to display three tab's in the entire screen
            let tabWidth = size.width / 3
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Text(tab.rawValue)
                        .font(.title3.bold())
                        .foregroundColor(activeTab == tab ? .primary : .gray)
                        .frame(width: tabWidth)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                activeTab = tab
                                /// Setting Scroll Progress Explicitly
                                scrollProgress = -CGFloat(tab.index)
                                tapState.startAnimation()
                            }
                        }
                }
            }
            .modifier(
                AnimationEndCallback(endValue: tapState.progress, onEnd: {
                    tapState.reset()
                })
            )
            .frame(width: CGFloat(Tab.allCases.count) * tabWidth)
            /// Starting At Center
            .padding(.leading, tabWidth)
            .offset(x: scrollProgress * tabWidth)
        }
        .frame(height: 40)
        .padding(.top, 15)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
    
    /// Image View
    @ViewBuilder
    func TabImageView(_ tab: Tab) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(tab.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
