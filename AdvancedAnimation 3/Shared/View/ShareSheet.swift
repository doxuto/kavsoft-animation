//
//  ShareSheet.swift
//  AdvancedAnimation (iOS)
//
//  Created by Balaji on 01/02/22.
//

import SwiftUI

// MARK: UIKit Share Sheet
struct ShareSheet: UIViewControllerRepresentable{
    
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        let view = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
