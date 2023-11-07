//
//  ImageAsset.swift
//  PopupImagePicker (iOS)
//
//  Created by Balaji on 25/05/22.
//

import SwiftUI
import PhotosUI

// MARK: Selected Image Asset Model
struct ImageAsset: Identifiable {
    var id: String = UUID().uuidString
    var asset: PHAsset
    var thumbnail: UIImage?
    // MARK: Selected Image Index
    var assetIndex: Int = -1
}
