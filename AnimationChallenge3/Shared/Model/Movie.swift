//
//  Movie.swift
//  AnimationChallenge3 (iOS)
//
//  Created by Balaji on 29/03/22.
//

import SwiftUI

// MARK: Movie Data Model and Sample Movie Data
struct Movie: Identifiable{
    var id = UUID().uuidString
    var movieTitle: String
    var artwork: String
}

var movies: [Movie] = [

    Movie(movieTitle: "Ad Astra", artwork: "Movie1"),
    Movie(movieTitle: "Star Wars", artwork: "Movie2"),
    Movie(movieTitle: "Toys Story 4", artwork: "Movie3"),
    Movie(movieTitle: "Lion King", artwork: "Movie4"),
    Movie(movieTitle: "Spider Man No Way Home", artwork: "Movie5"),
    Movie(movieTitle: "Shang Chi", artwork: "Movie6"),
    Movie(movieTitle: "Hawkeye", artwork: "Movie7"),
]

// MARK: Dummy Text
var sampleText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
