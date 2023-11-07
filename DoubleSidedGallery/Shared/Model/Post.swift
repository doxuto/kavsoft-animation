//
//  Post.swift
//  DoubleSidedGallery (iOS)
//
//  Created by Balaji on 11/10/21.
//

import SwiftUI

// Post Model...
struct Post: Identifiable,Hashable {
    var id = UUID().uuidString
    var postImage: String
}
