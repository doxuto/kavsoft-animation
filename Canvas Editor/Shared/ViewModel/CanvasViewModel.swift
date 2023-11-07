//
//  CanvasViewModel.swift
//  Canvas Editor (iOS)
//
//  Created by Balaji on 05/05/22.
//

import SwiftUI

// MARK: Holds All Canvas Data
class CanvasViewModel: NSObject,ObservableObject {
    // MARK: Canvas Stack
    @Published var stack: [StackItem] = []
    
    // MARK: Image Picker Properties
    @Published var shoeImagePicker: Bool = false
    @Published var imageData: Data = .init(count: 0)
    
    // MARK: Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: Delete Alert
    @Published var currentlyTappedItem: StackItem?
    @Published var showDeleteAlert: Bool = false
    
    // MARK: Adding Image to Stack
    func addImageToStack(image: UIImage){
        // MARK: Creating SwiftUI Image View And Appending Into Stack
        let imageView = Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
        
        stack.append(StackItem(view: AnyView(imageView)))
    }
    
    // MARK: Saving Canvas Image
    func saveCanvasImage<Content: View>(height: CGFloat,@ViewBuilder content: @escaping ()->Content){
        // Thats Happening Bcz of SafeArea Top Value
        // Its Pushing View to Bottom
        // Removing SafeArea Top Value
        let uiView = UIHostingController(rootView: content().padding(.top,-safeArea().top))
        let frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: height))
        uiView.view.frame = frame
        
        // MARK: Drawing Image
        // If you Need Higher Quality Image then Adjust Scaling To 2-3etc.
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        uiView.view.drawHierarchy(in: frame, afterScreenUpdates: true)
        // Retreving Current Drawn Image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // Closing Context
        UIGraphicsEndImageContext()
        if let newImage = newImage {
            writeToAlbum(image: newImage)
        }
    }
    
    // MARK: Writting To Album
    func writeToAlbum(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc
    func saveCompletion(_ image: UIImage,didFinishSavingWithError error: Error?,contextInfo: UnsafeRawPointer){
        if let error = error {
            self.errorMessage = error.localizedDescription
            self.showError.toggle()
        }else{
            self.errorMessage = "Saved Successfully!"
            self.showError.toggle()
        }
    }
    
    func safeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}
