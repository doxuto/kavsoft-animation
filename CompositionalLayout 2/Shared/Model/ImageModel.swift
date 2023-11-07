//
//  ImageModel.swift
//  CompositionalLayout (iOS)
//
//  Created by Balaji on 23/04/22.
//

import SwiftUI

struct ImageModel: Identifiable,Codable,Hashable {
    var id: String
    var download_url: String
    
    enum CodingKeys: String,CodingKey{
        case id
        case download_url
    }
}
