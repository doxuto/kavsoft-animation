//
//  MenuBarExtraApp.swift
//  MenuBarExtra
//
//  Created by Balaji on 25/10/22.
//

import SwiftUI

@main
struct MenuBarExtraApp: App {
    var body: some Scene {
        // MARK: If You Want Both macOS App And Menu Bar App
        // Then Add Window Group And MenuBarExtra
//        WindowGroup{
//            ContentView()
//        }
        // MARK: For Menu Bar App Simply Remove the Window Group
        // And Add MenuBarExtra
        MenuBarExtra {
            // MARK: Sample macOS Control Center UI
            ControlCentreView()
        } label: {
            Image(systemName: "switch.2")
        }
        .menuBarExtraStyle(.window)
        // MARK: Menu Bar Style
        // 1. Menu (List Type)
        // 2. Window (View Type)
    }
    
    @ViewBuilder
    func ControlCentreView()->some View{
        // MARK: Instead Of VStack, Hstack, I'm going to Use Grid Which is Available from macOS 13
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow(alignment: .top){
                VStack(spacing: 12){
                    ControlView(icon: "wifi.circle.fill", title: "Wi-Fi", subTitle: "Home WiFi")
                    ControlView(icon: "wave.3.right.circle.fill", title: "Bluetooth", subTitle: "Magic Keyboard")
                    ControlView(icon: "airplayvideo.circle.fill", title: "AirDrop", subTitle: "Contacts Only")
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .borderView()
                
                Grid(verticalSpacing: 12){
                    GridRow {
                        HStack{
                            Image(systemName: "moon.circle.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.multicolor)
                                .foregroundStyle(.purple, .primary)
                            
                            Text("Do Not Disturb")
                                .font(.callout)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }
                        .borderView()
                        .gridCellColumns(2)
                    }
                    
                    GridRow {
                        SubControlView(icon: "rectangle.3.group", title: "Stage\nManager")
                        
                        SubControlView(icon: "rectangle.fill.on.rectangle.fill", title: "Screen\nMirroring")
                    }
                }
                .gridCellUnsizedAxes(.vertical)
            }
            
            GridRow{
                VStack{
                    DisabledSeeker(icon: "sun.max", title: "Display")
                    
                    DisabledSeeker(icon: "airpods.gen3", title: "Sound")
                }
                .gridCellColumns(2)
            }
        }
        .padding(10)
        .frame(width: 350)
    }
    
    // MARK: Disabled Seeker
    @ViewBuilder
    func DisabledSeeker(icon: String,title: String)->some View{
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.callout)
                .foregroundColor(.primary)
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.primary)
                    .opacity(0.15)
                
                Image(systemName: icon)
                    .foregroundStyle(.primary)
                    .padding(.leading,8)
                    .opacity(0.8)
            }
            .frame(height: 25)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .borderView()
    }
    
    @ViewBuilder
    func SubControlView(icon: String,title: String)->some View{
        VStack(spacing: 4){
            Image(systemName: icon)
                .font(.title2)
            
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .borderView()
    }
    
    // MARK: Control View (Wi-Fi,etc)
    @ViewBuilder
    func ControlView(icon: String,title: String,subTitle: String)->some View{
        HStack(spacing: 5){
            Image(systemName: icon)
                .font(.largeTitle)
                // MARK: Since We're going to apply multiple color's on SFSymbol
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.blue, .white)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
                
                Text(subTitle)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .opacity(0.7)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

// MARK: Border And Shadows For Rounded Rectangles
extension View{
    @ViewBuilder
    func borderView()->some View{
        self
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 3, y: 3)
            .shadow(color: .black.opacity(0.1), radius: 5, x: -3, y: -3)
    }
}
