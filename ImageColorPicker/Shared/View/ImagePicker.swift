//
//  ImagePicker.swift
//  ImageColorPicker (iOS)
//
//  Created by Balaji on 13/01/23.
//

import SwiftUI
import PhotosUI

// MARK: Image Picker
struct ImagePicker: UIViewControllerRepresentable{
    @Binding var showPicker: Bool
    @Binding var imageData: Data
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    // Fetching Selected Image
    class Coordinator: NSObject,PHPickerViewControllerDelegate{
        var parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Since we have only one image in limit so first one is our Image
            if let first = results.first{
                first.itemProvider.loadObject(ofClass: UIImage.self) {[self] result, err in
                    guard let image = result as? UIImage else{
                        parent.showPicker.toggle()
                        return
                    }
                    
                    parent.imageData = image.jpegData(compressionQuality: 1) ?? .init(count: 0)
                    // Closing Picker
                    parent.showPicker.toggle()
                }
            }
            else{
                parent.showPicker.toggle()
            }
        }
    }
}
