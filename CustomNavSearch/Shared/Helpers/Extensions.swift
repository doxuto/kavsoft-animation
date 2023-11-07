//
//  Extensions.swift
//  CustomNavSearch (iOS)
//
//  Created by Balaji on 05/01/22.
//

import SwiftUI

// MARK: Customization Options for Navigation Bar
extension View{
    
    func setNavbarColor(color: Color){
        
        // MARK: Updating Nav Bar Color
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil,userInfo: [
            
                // Sending Color
                "color": color
            ])
        }
    }
    
    func resetNavBar(){
        // MARK: Resetting Nav Bar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil)
        }
    }
    
    func setNavbarTitleColor(color: Color){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil,userInfo: [
            
                // Sending Color
                "color": color,
                "forTitle": true
            ])
        }
    }
}

// MARK: NavigationController Helpers
extension UINavigationController{
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Since it's base navigation Controller load method
        // so what ever changes done here will reflect on navigation bar
        
        // MARK: Notification Observer
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNavBar(notification:)), name: NSNotification.Name("UPDATENAVBAR"), object: nil)
    }
    
    @objc
    func updateNavBar(notification: Notification){
        
        if let info = notification.userInfo{
            
            let color = info["color"] as! Color
            
            if let _ = info["forTitle"]{
                
                // MARK: Title Color
                // Update color in Apperance
                navigationBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                navigationBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                navigationBar.compactAppearance?.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                navigationBar.compactAppearance?.titleTextAttributes = [.foregroundColor: UIColor(color)]
                
                return
            }
            
            if color == .clear{
                
                // Transparent Nav Bar
                let transparentApperance = UINavigationBarAppearance()
                transparentApperance.configureWithTransparentBackground()
                
                navigationBar.standardAppearance = transparentApperance
                navigationBar.scrollEdgeAppearance = transparentApperance
                navigationBar.compactAppearance = transparentApperance
                
                return
            }
            
            // MARK: Updating Nav Bar Color
            let apperance = UINavigationBarAppearance()
            apperance.backgroundColor = UIColor(color)
            
            navigationBar.standardAppearance = apperance
            navigationBar.scrollEdgeAppearance = apperance
            navigationBar.compactAppearance = apperance
        }
        else{
            // MARK: Reset Nav bar
            let apperance = UINavigationBarAppearance()
            
            let transparentApperance = UINavigationBarAppearance()
            transparentApperance.configureWithTransparentBackground()
            
            navigationBar.standardAppearance = apperance
            navigationBar.scrollEdgeAppearance = transparentApperance
            navigationBar.compactAppearance = apperance
        }
    }
}
