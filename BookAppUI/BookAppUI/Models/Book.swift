//
//  Book.swift
//  BookAppUI
//
//  Created by Balaji on 05/03/23.
//

import SwiftUI

/// Book Model
struct Book: Identifiable,Hashable{
    var id: String = UUID().uuidString
    var title: String
    var imageName: String
    var author: String
    var rating: Int
    var bookViews: Int
}

var sampleBooks: [Book] = [
    .init(title: "Five Feet Apart", imageName: "Book 1", author: "Rachael Lippincott", rating: 4, bookViews: 1023),
    .init(title: "The Alchemist", imageName: "Book 2", author: "William B.Irvine", rating: 5, bookViews: 2049),
    .init(title: "Booke of Hapiness", imageName: "Book 3", author: "Anne", rating: 4, bookViews: 920),
    .init(title: "Living Alone", imageName: "Book 4", author: "William Lippincott", rating: 3, bookViews: 560),
    .init(title: "Five Feet Apart", imageName: "Book 5", author: "Jenna Lippincott", rating: 5, bookViews: 240),
]
