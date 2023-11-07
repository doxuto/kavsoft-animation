//
//  Extensions.swift
//  ResponsiveUI (iOS)
//
//  Created by Balaji on 04/03/22.
//

import SwiftUI

// MARK: Displaying Side bar always like iPad Settings App
extension UISplitViewController{
    open override func viewDidLoad() {
        self.preferredDisplayMode = .twoOverSecondary
        self.preferredSplitBehavior = .displace
        
        // Updating Primary View column Fraction
        self.preferredPrimaryColumnWidthFraction = 0.3
        
        // Updating Dynamically with the help of NotificationCenter calls
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateView(notification:)), name: NSNotification.Name("UPDATEFRACTION"), object: nil)
    }
    
    @objc
    func UpdateView(notification: Notification){
        if let info = notification.userInfo,let fraction = info["fraction"] as? Double{
            self.preferredPrimaryColumnWidthFraction = fraction
        }
    }
}
