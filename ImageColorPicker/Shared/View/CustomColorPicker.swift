//
//  CustomColorPicker.swift
//  ImageColorPicker (iOS)
//
//  Created by Balaji on 30/01/22.
//

import SwiftUI

// MARK: Custom Color Picker with the Help of UIColorPicker
struct CustomColorPicker: UIViewControllerRepresentable{
    // MARK: Picker Values
    @Binding var color: Color
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.selectedColor = UIColor(color)
        // Connecting Delegate
        picker.delegate = context.coordinator
        // Removing Title
        picker.title = ""
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        // Changing Tint Color...
        uiViewController.view.tintColor = (color.isDarkColor ? .white : .black)
    }
    
    // MARK: Delegate Methods
    class Coordinator: NSObject,UIColorPickerViewControllerDelegate{
        var parent: CustomColorPicker
        
        init(parent: CustomColorPicker) {
            self.parent = parent
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            // Updating Color
            parent.color = Color(viewController.selectedColor)
        }
        
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.color = Color(color)
        }
    }
}
