//
//  Download.swift
//  Analytics (iOS)
//
//  Created by Balaji on 01/10/21.
//

import SwiftUI

// Sample Download Model for Bar Graph...
struct Download: Identifiable{
    
    var id = UUID().uuidString
    var downloads: CGFloat
    var weekDay: String
}

var downloads: [Download] = [

    Download(downloads: 500, weekDay: "Mon"),
    Download(downloads: 240, weekDay: "Tue"),
    Download(downloads: 350, weekDay: "Wed"),
    Download(downloads: 430, weekDay: "Thu"),
    Download(downloads: 690, weekDay: "Fri"),
    Download(downloads: 540, weekDay: "Sat"),
    Download(downloads: 920, weekDay: "Sun"),
]
