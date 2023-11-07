//
//  Puzzle.swift
//  QuizGame (iOS)
//
//  Created by Balaji on 14/02/22.
//

import SwiftUI

// MARK: Puzzle Model and sample Puzzles
struct Puzzle: Identifiable{
    var id: String = UUID().uuidString
    var imageName: String
    var answer: String
    var jumbbledWord: String
    
    // MARK: Spiliting Jumbbled word into array of Identifiable Characters
    var letters: [Letter] = []
}

struct Letter: Identifiable{
    var id = UUID().uuidString
    var value: String
}

var puzzles: [Puzzle] = [

    Puzzle(imageName: "Crown", answer: "Crown", jumbbledWord: "CUROROWKN"),
    Puzzle(imageName: "Justine", answer: "Justine", jumbbledWord: "JENIUSTOK")
]
