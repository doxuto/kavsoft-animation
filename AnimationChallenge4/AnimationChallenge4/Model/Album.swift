//
//  Album.swift
//  AnimationChallenge4
//
//  Created by Balaji on 14/06/22.
//

import SwiftUI

// MARK: Album Model And Sample Data
struct Album: Identifiable{
    var id = UUID().uuidString
    var albumName: String
    var albumImage: String
    var rating: Int
    var showDisk: Bool = false
    var diskOffset: CGFloat = 0
}

var sampleAlbums: [Album] = [

    Album(albumName: "Positions", albumImage: "Album2",rating: 4),
    Album(albumName: "The Best", albumImage: "Album3",rating: 5),
    Album(albumName: "My Everything", albumImage: "Album4",rating: 5),
    Album(albumName: "Yours Truly", albumImage: "Album5",rating: 4),
    Album(albumName: "Sweetener", albumImage: "Album6",rating: 4),
    Album(albumName: "Rain On Me", albumImage: "Album7",rating: 4),
]

// MARK: Sample Text
let sampleText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
