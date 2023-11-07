//
//  PhotosPickerModel.swift
//  NewPhotosPicker
//
//  Created by Balaji on 24/06/22.
//

import SwiftUI
import PhotosUI

class PhotosPickerModel: ObservableObject {
    // MARK: Loaded Images
    @Published var loadedImages: [MediaFile] = []
    // MARK: Selected Photo
    @Published var selectedPhoto: PhotosPickerItem?{
        didSet{
            // MARK: If Photo is Selected, Then Processing The Image
            if let selectedPhoto{
                processPhoto(photo: selectedPhoto)
            }
        }
    }
    
    // MARK: Multiple Photos Selection
    @Published var selectedPhotos: [PhotosPickerItem] = []{
        didSet{
            for photo in selectedPhotos{
                processPhoto(photo: photo)
            }
        }
    }
    
    func processPhoto(photo: PhotosPickerItem){
        // MARK: Extracting Image Data
        // Note: SwiftUI Image is Confroming Transferable But For Some Reason It will Reading Some of the Images
        // So We're Using Data Transferable
        // Note: It's Still In Beta
        photo.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data, let image = UIImage(data: data){
                        self.loadedImages.append(.init(image: Image(uiImage: image), data: data))
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}
