//
//  SnapCarouselHelper.swift
//  SnapCarousel
//
//  Created by Balaji on 10/02/23.
//

import SwiftUI

/// Retreiving Embeded UIScrollView from the SwiftUI ScrollView
struct SnapCarouselHelper: UIViewRepresentable {
    /// Retreive what ever properties you needed from the ScrollView with the help of @Binding
    var pageWidth: CGFloat
    var pageCount: Int
    @Binding var index: Int
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = .fast
                scrollView.delegate = context.coordinator
                context.coordinator.pageCount = pageCount
                context.coordinator.pageWidth = pageWidth
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: SnapCarouselHelper
        var pageCount: Int = 0
        var pageWidth: CGFloat = 0
        init(parent: SnapCarouselHelper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // print(scrollView.contentOffset.x)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            /// Adding Velocity too, for making perfect scroll animation
            let targetEnd = scrollView.contentOffset.x + (velocity.x * 60)
            let targetIndex = (targetEnd / pageWidth).rounded()
            
            /// Updating Current Index
            let index = min(max(Int(targetIndex), 0), pageCount - 1)
            parent.index = index
            
            targetContentOffset.pointee.x = targetIndex * pageWidth
        }
    }
}

struct SnapCarouselHelper_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
