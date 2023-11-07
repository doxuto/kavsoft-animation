//
//  ImageFile.swift
//  SnapCarousel
//
//  Created by Balaji on 10/02/23.
//

import SwiftUI

/// Image Model
struct ImageFile: Identifiable {
    var id: UUID = .init()
    var imageName: String
    var thumbnail: UIImage?
}
