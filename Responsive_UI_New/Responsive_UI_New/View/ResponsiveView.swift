//
//  ResponsiveView.swift
//  Responsive_UI_New
//
//  Created by Balaji on 03/09/22.
//

import SwiftUI

// MARK: Custom View Which will Give Useful Properties for Adpotable UI
struct ResponsiveView<Content: View>: View {
    var content: (Properties)-> Content
    init(@ViewBuilder content: @escaping (Properties)->Content) {
        self.content = content
    }
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            let isLandscape = size.width > size.height
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let isMaxSplit = isSplit() && size.width < 400
            
            // MARK: In Vertical Hiding Side Bar Completely
            // In Horizontal Showing Side bar for 0.75 Fraction
            
            let isAdoptable = isIpad && (isLandscape ? !isMaxSplit : !isSplit())
            let properties = Properties(isLandscape: isLandscape, isiPad: isIpad, isSplit: isSplit(), isMaxSplit: isMaxSplit,isAdoptable: isAdoptable, size: size)
            
            content(properties)
                .frame(width: size.width, height: size.height)
        }
    }
    
    // MARK: Simple Way to Find it the app is in Split View
    func isSplit()->Bool{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return false}
        return screen.windows.first?.frame.size != screen.screen.bounds.size
    }
}

struct ResponsiveView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Properties{
    var isLandscape: Bool
    var isiPad: Bool
    var isSplit: Bool
    // MARK: If the App size is reduced more than 1/3 in split mode on iPad
    var isMaxSplit: Bool
    var isAdoptable: Bool
    var size: CGSize
}
