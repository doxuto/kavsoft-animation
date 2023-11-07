//
//  Note.swift
//  NotesApp
//
//  Created by Balaji Venkatesh on 24/10/23.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var content: String
    var isFavourite: Bool = false
    var category: NoteCategory?
    
    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}
