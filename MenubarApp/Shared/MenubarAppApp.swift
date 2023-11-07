//
//  MenubarAppApp.swift
//  Shared
//
//  Created by Balaji on 17/04/22.
//

import SwiftUI

@main
struct MenubarAppApp: App {
    // MARK: Linking App Delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: Making it as Pure Menu Bar App

// MARK: Setting Up Menu Bar Icon and Menu Bar Popover area
class AppDelegate: NSObject,ObservableObject,NSApplicationDelegate{
    // MARK: Properties
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setUpMacMenu()
    }
    
    func setUpMacMenu(){
        // MARK: Popover Properties
        popover.animates = true
        popover.behavior = .transient
        
        // MARK: Linking SwiftUI View
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: Home())
        
        // MARK: Making it as Key Window
        popover.contentViewController?.view.window?.makeKey()
        
        // MARK: Setting Menu Bar Icon and Action
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button{
            menuButton.image = .init(systemSymbolName: "dollarsign.circle.fill", accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonAction(sender:))
        }
    }
    
    @objc func menuButtonAction(sender: AnyObject){
        // MARK: Showing/Closing Popover
        if popover.isShown{
            popover.performClose(sender)
        }
        else{
            if let menuButton = statusItem?.button{
                popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
}
