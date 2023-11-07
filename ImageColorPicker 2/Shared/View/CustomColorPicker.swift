//
//  CustomColorPicker.swift
//  ImageColorPicker (iOS)
//
//  Created by Balaji on 30/01/22.
//

import SwiftUI
import PhotosUI

// MARK: Making extension to call Image Color Picker
extension View{
    func imageColorPicker(showPicker: Binding<Bool>,color: Binding<Color>)->some View{
        return self
        // Full Sheet
            .fullScreenCover(isPresented: showPicker) {
                
            } content: {
                Helper(showPicker: showPicker, color: color)
            }
    }
}

// MARK: Custom View for Color Picker
struct Helper: View{
    @Binding var showPicker: Bool
    @Binding var color: Color
    
    // Image Picker Value
    @State var showImagePicker: Bool = false
    @State var imageData: Data = .init(count: 0)
    
    var body: some View{
        
        NavigationView{
            
            VStack(spacing: 10){
                
                // MARK: Image Picker View
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    VStack(spacing: 12){
                        
                        if let image = UIImage(data: imageData){
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                        }
                        else{
                            Image(systemName: "plus")
                                .font(.system(size: 35))
                            
                            Text("Tap to add Image")
                                .font(.system(size: 14, weight: .light))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Show Image Picker
                        showImagePicker.toggle()
                    }
                }
                
                ZStack(alignment: .top){
                    
                    // Displaying the Selected Color
                    Rectangle()
                        .fill(color)
                        .frame(height: 90)
                    
                    // Since we need only Live picker button
                    // Simply setting the height of the picker to 50
                    // And clipping the remaining content
                    // So that the top Bar will only Appear
                    CustomColorPicker(color: $color)
                    // Centering It
                        .frame(width: 100,height: 50,alignment: .topLeading)
                        .clipped()
                        .offset(x: 20)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationTitle("Image Color Picker")
            .navigationBarTitleDisplayMode(.inline)
        // MARK: Close Button
            .toolbar {
                Button("Close"){
                    showPicker.toggle()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                
            } content: {
                ImagePicker(showPicker: $showImagePicker, imageData: $imageData)
            }

        }
    }
}

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

// MARK: Simple Extension to find whether the color is dark or light
extension Color{
    
    var isDarkColor: Bool {

        return UIColor(self).isDarkColor
    }
}

extension UIColor{
    
    var isDarkColor: Bool {
        var (r, g, b, a): (CGFloat,CGFloat,CGFloat,CGFloat) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}
