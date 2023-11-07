//
//  Message.swift
//  iMessageCardSwipe
//
//  Created by Balaji on 01/10/22.
//

import SwiftUI

// MARK: Sample Message Model
struct Message: Identifiable,Equatable{
    var id: String = UUID().uuidString
    var imageFile: String
}
