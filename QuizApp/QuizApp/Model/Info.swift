//
//  Info.swift
//  QuizApp
//
//  Created by Balaji on 16/01/23.
//

import SwiftUI

// MARK: Quiz Info Codable Model
struct Info: Codable{
    var title: String
    var peopleAttended: Int
    var rules: [String]
    
    enum CodingKeys: CodingKey {
        case title
        case peopleAttended
        case rules
    }
}
