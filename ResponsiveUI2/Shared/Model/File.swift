//
//  File.swift
//  ResponsiveUI2 (iOS)
//
//  Created by Balaji on 03/06/22.
//

import SwiftUI

// MARK: File Model And Sample Data
struct File: Identifiable{
    var id: String = UUID().uuidString
    var fileType: String
    var fileIcon: String
    var fileDate: String
    var fileSize: String
}

var sampleFiles: [File] = [
    File(fileType: "XD File", fileIcon: "XD", fileDate: "01-06-22", fileSize: "10MB"),
    File(fileType: "Figma File", fileIcon: "Figma", fileDate: "02-06-22", fileSize: "1MB"),
    File(fileType: "Documents", fileIcon: "Docs", fileDate: "03-06-22", fileSize: "5MB"),
    File(fileType: "Sound File", fileIcon: "Sound", fileDate: "18-05-22", fileSize: "12MB"),
    File(fileType: "Media File", fileIcon: "Media", fileDate: "16-05-22", fileSize: "9MB"),
    File(fileType: "Excel File", fileIcon: "Excel", fileDate: "04-05-22", fileSize: "1MB"),
    File(fileType: "PDF File", fileIcon: "PDF", fileDate: "09-05-22", fileSize: "2MB"),
]
