//
//  Question.swift
//  QuizApp
//
//  Created by Balaji on 16/01/23.
//

import SwiftUI

// MARK: Quiz Question Codable Model
struct Question: Identifiable, Codable{
    var id: UUID = .init()
    var question: String
    var options: [String]
    var answer: String
    
    /// - For UI State Updates
    var tappedAnswer: String = ""
    
    enum CodingKeys: CodingKey {
        case question
        case options
        case answer
    }
}
