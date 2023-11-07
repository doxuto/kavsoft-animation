//
//  ImagePicker.swift
//  DragImagePicker
//
//  Created by Balaji on 19/08/23.
//

import SwiftUI
import PhotosUI

/// Custom Image Picker
/// Included With Drag & Drop
struct ImagePicker: View {
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChange: (UIImage) -> ()
    /// View Properties
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    /// Preview Image
    @State private var previewImage: UIImage?
    /// Loading Status
    @State private var isLoading: Bool = false
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(tint)
                
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            /// Displaying Preview Image, if any
            .opacity(previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                }
            }
            /// Displaying Loading UI
            .overlay {
                if isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            }
            /// Animating Changes
            .animation(.snappy, value: isLoading)
            .animation(.snappy, value: previewImage)
            .contentShape(.rect)
            /// Implementing Drop Action and Retreving Dropped Image
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    /// Sending the Image using the callback
                    generateImageThumbnail(droppedImage, size)
                    onImageChange(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
            .onTapGesture {
                showImagePicker.toggle()
            }
            /// Now Let's Implement Manual Image Picker
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            /// Let's Process the Selected Image
            .optionalViewModifier { contentView in
                if #available(iOS 17, *) {
                    contentView
                        .onChange(of: photoItem) { oldValue, newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                } else {
                    contentView
                        .onChange(of: photoItem) { newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                }
            }
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
            }
        }
    }
    
    /// Extracting Image from PhotoItem
    func extractImage(_ photoItem: PhotosPickerItem, _ viewSize: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else {
                return
            }
            
            /// UI Must be Updated on Main Thread
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    /// Creating Preview
                    generateImageThumbnail(selectedImage, viewSize)
                    /// Send Orignal Image to Callback
                    onImageChange(selectedImage)
                }
                
                /// Clearing PhotoItem
                self.photoItem = nil
            }
        }
    }
    
    /// Creating Image Thumbnail
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        isLoading = true
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            /// UI Must be Updated on Main Thread
            await MainActor.run {
                previewImage = thumbnailImage
                isLoading = false
            }
        }
    }
}

/// Custom Optional View Modifier
extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}
