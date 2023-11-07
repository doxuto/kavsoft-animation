//
//  ImagePickerViewModel.swift
//  PopupImagePicker (iOS)
//
//  Created by Balaji on 25/05/22.
//

import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
    // MARK: Properties
    @Published var fetchedImages: [ImageAsset] = []
    @Published var selectedImages: [ImageAsset] = []
    
    init(){
        fetchImages()
    }
    
    // MARK: Fetching Images
    func fetchImages(){
        let options = PHFetchOptions()
        // MARK: Modify As Per Your Wish
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, _, _ in
            let imageAsset: ImageAsset = .init(asset: asset)
            self.fetchedImages.append(imageAsset)
        }
    }
}
