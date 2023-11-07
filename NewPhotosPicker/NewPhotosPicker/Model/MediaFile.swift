//
//  MediaFile.swift
//  NewPhotosPicker
//
//  Created by Balaji on 24/06/22.
//

import SwiftUI

struct MediaFile: Identifiable {
    var id: String = UUID().uuidString
    var image: Image
    var data: Data
}
