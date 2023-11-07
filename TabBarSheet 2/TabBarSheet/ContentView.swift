//
//  ContentView.swift
//  TabBarSheet
//
//  Created by Balaji on 21/08/23.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    /// Apple Park Location Coordinates
    static var applePark: MKCoordinateRegion {
        return .init(
            center: .init(latitude: 37.3346, longitude: -122.0090),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
}

struct ContentView: View {
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(SceneDelegate.self) private var sceneDelegate
    var body: some View {
        @Bindable var bindableObject = windowSharedModel
        TabView(selection: $bindableObject.activeTab) {
            NavigationStack {
                Text("People")
            }
            .tag(Tab.people)
            .hideNativeTabBar()
            
            NavigationStack {
                /// Sample Map View
                Map(initialPosition: .region(.applePark))
            }
            .tag(Tab.devices)
            .hideNativeTabBar()
            
            NavigationStack {
                Text("Items")
            }
            .tag(Tab.items)
            .hideNativeTabBar()
            
            NavigationStack {
                Text("Me")
            }
            .tag(Tab.me)
            .hideNativeTabBar()
        }
        .tabSheet(initialHeight: 110, sheetCornerRadius: 15) {
            NavigationStack {
                ScrollView {
                    /// Showing Some Sample Mock Devices
                    VStack(spacing: 15) {
                        if windowSharedModel.activeTab == .devices {
                            DeviceRowView("iphone", "iJustine's iPhone", "Home")
                            DeviceRowView("ipad", "iJustine's iPad", "Home")
                            DeviceRowView("applewatch", "iJustine's Watch Ultra", "Home")
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .toolbar(content: {
                    /// Leading Title
                    ToolbarItem(placement: .topBarLeading) {
                        Text(windowSharedModel.activeTab.title)
                            .font(.title3.bold())
                    }
                    
                    /// Showing Plus Button for only Devices
                    if windowSharedModel.activeTab == .devices {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {}, label: {
                                Image(systemName: "plus")
                            })
                        }
                    }
                })
            }
        }
        .onAppear {
            guard sceneDelegate.tabWindow == nil else { return }
            sceneDelegate.addTabBar(windowSharedModel)
        }
    }
    
    /// Device Row View
    @ViewBuilder
    func DeviceRowView(_ image: String, _ title: String, _ subTitle: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: image)
                .font(.title2)
                .padding(12)
                .background(.background, in: .circle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.bold)
                
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("0 km")
                .font(.callout)
                .foregroundStyle(.gray)
        }
    }
}

/// Custom Tab Bar
struct CustomTabBar: View {
    @Environment(WindowSharedModel.self) private var windowSharedModel
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        windowSharedModel.activeTab = tab
                    } label: {
                        VStack {
                            Image(systemName: tab.rawValue)
                                .font(.title2)
                            
                            Text(tab.title)
                                .font(.caption)
                        }
                        .foregroundStyle(windowSharedModel.activeTab == tab ? Color.accentColor : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                    }
                }
            }
            .frame(height: 55)
        }
        .background(.regularMaterial)
        .offset(y: windowSharedModel.hideTabBar ? 100 : 0)
        .animation(.snappy(duration: 0.25, extraBounce: 0), value: windowSharedModel.hideTabBar)
    }
}

#Preview {
    ContentView()
}
