//
//  PageControl.swift
//  tvOSInfiniteCarousel
//
//  Created by Balaji on 19/04/23.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    /// Page Properties
    var totalPages: Int
    var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = totalPages
        control.currentPage = currentPage
        control.backgroundStyle = .prominent
        control.allowsContinuousInteraction = false
        control.isUserInteractionEnabled = false
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = totalPages
        uiView.currentPage = currentPage
    }
}
