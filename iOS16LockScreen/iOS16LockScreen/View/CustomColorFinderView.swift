//
//  CustomColorFinderView.swift
//  iOS16LockScreen
//
//  Created by Balaji on 13/08/22.
//

import SwiftUI

// MARK: This View will return Color Based on the XY Coordinates
struct CustomColorFinderView<Content: View>: UIViewRepresentable {
    @EnvironmentObject var lockscreeModel: LockscreenModel
    var content: Content
    var onLoad: (UIView)->()
    init(@ViewBuilder content: @escaping ()->Content,onLoad: @escaping (UIView)->()) {
        self.content = content()
        self.onLoad = onLoad
    }
    
    func makeUIView(context: Context) -> UIView {
        let size = UIApplication.shared.screenSize()
        let host = UIHostingController(rootView: content
            .frame(width: size.width, height: size.height)
            .environmentObject(lockscreeModel)
        )
        host.view.frame = CGRect(origin: .zero, size: size)
        
        return host.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Simply Getting the UIView as Reference So that we can Check Color of the View
        DispatchQueue.main.async {
            onLoad(uiView)
        }
    }
}
