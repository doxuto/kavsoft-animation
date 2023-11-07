//
//  FindScrollView.swift
//  tvOSInfiniteCarousel
//
//  Created by Balaji on 19/04/23.
//

import SwiftUI

struct FindScrollView: UIViewRepresentable {
    var size: CGSize
    @Binding var currentIndex: Int
    var totalCount: Int
    var leftReset: (Bool) -> ()
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            let superView = uiView.superview?.superview?.superview
            if let view = superView as? UIScrollView {
                context.coordinator.size = size
                context.coordinator.totalCount = totalCount
                view.delegate = context.coordinator
                
                view.decelerationRate = .fast
                if !context.coordinator.isLoaded {
                    view.setContentOffset(CGPoint(x: size.width, y: 0), animated: false)
                    context.coordinator.isLoaded = true
                }
                #if os(iOS)
                view.isPagingEnabled = true
                #endif
            } else {
                print("No ScrollView Found")
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: FindScrollView
        init(parent: FindScrollView) {
            self.parent = parent
        }
        
        var size: CGSize = .zero
        var totalCount: Int = 0
        var isLoaded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let contentOffset = scrollView.contentOffset.x
            
            parent.currentIndex = (Int((contentOffset / size.width).rounded())) - 1
            
            if contentOffset <= 0 {
                let circularContentOffset = CGFloat(totalCount - 2) * size.width
                scrollView.setContentOffset(CGPoint(x: circularContentOffset, y: 0), animated: false)
                parent.leftReset(false)
            }
            
            if (contentOffset + scrollView.contentInset.left) >= (size.width * CGFloat(totalCount - 1)) - (size.width * 0.5) {
                let circularContentOffset = (size.width * 0.5) - scrollView.contentInset.left
                scrollView.setContentOffset(CGPoint(x: circularContentOffset, y: 0), animated: false)
                parent.leftReset(true)
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        }
    }
}

/// Extracting TextField From the Subviews
fileprivate extension UIView {
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
    
    /// Finiding the UIView is TextField or Not
    var findScrollView: UIScrollView? {
        if let textField = allSubViews.first(where: { view in
            view is UIScrollView
        }) as? UIScrollView {
            return textField
        }
        
        return nil
    }
}
