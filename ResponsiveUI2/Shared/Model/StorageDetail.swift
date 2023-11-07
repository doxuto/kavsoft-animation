//
//  StorageDetail.swift
//  ResponsiveUI2 (iOS)
//
//  Created by Balaji on 03/06/22.
//

import SwiftUI

// MARK: Storage Detail Model And Sample Data
struct StorageDetail: Identifiable{
    var id: String = UUID().uuidString
    var type: String
    var icon: String
    var files: String
    var size: String
    var progress: CGFloat
    var progressColor: Color
}

var sampleStorageDetails: [StorageDetail] = [
    StorageDetail(type: "Document Files", icon: "DocumentIcon", files: "129", size: "1.3GB", progress: 0.3, progressColor: Color("Documents")),
    StorageDetail(type: "Media Files", icon: "Medias", files: "98", size: "2.3GB", progress: 0.2, progressColor: Color("Media")),
    StorageDetail(type: "Other Files", icon: "Folder", files: "25", size: "1.0GB", progress: 0.2, progressColor: Color.yellow),
    StorageDetail(type: "Unknown", icon: "Unknown", files: "220", size: "3.3GB", progress: 0.1, progressColor: Color.red),
]
