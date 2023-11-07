//
//  Storage.swift
//  ResponsiveUI2 (iOS)
//
//  Created by Balaji on 03/06/22.
//

import SwiftUI

// MARK: Storage Model And Sample Data
struct Storage: Identifiable{
    var id = UUID().uuidString
    var title: String
    var icon: String
    var fileCount: String
    var maxSize: String
    var progress: CGFloat
    var progressColor: Color
}

var sampleStorages: [Storage] = [
    Storage(title: "Documents", icon: "DocumentIcon", fileCount: "1138", maxSize: "10GB", progress: 0.4, progressColor: Color("Documents")),
    Storage(title: "Google Drive", icon: "GoogleDrive", fileCount: "1500", maxSize: "15GB", progress: 0.5, progressColor: Color("GDrive")),
    Storage(title: "One Drive", icon: "OneDrive", fileCount: "190", maxSize: "5GB", progress: 0.1, progressColor: Color("OneDrive")),
    Storage(title: "DropBox", icon: "Dropbox", fileCount: "90", maxSize: "2GB", progress: 0.2, progressColor: Color("DropBox")),
]
