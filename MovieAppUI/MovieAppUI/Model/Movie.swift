//
//  Movie.swift
//  MovieAppUI
//
//  Created by Balaji on 08/08/22.
//

import SwiftUI

// MARK: Movie Model & Sample Movies
struct Movie: Identifiable,Equatable{
    var id = UUID().uuidString
    var movieTitle: String
    var artwork: String
}

var movies: [Movie] = [
   Movie(movieTitle: "Ad Astra", artwork: "Movie1"),
    Movie(movieTitle: "Star Wars", artwork: "Movie2"),
    Movie(movieTitle: "Toys Story 4", artwork: "Movie3"),
    Movie(movieTitle: "Thor Love & Thunder", artwork: "Movie4"),
    Movie(movieTitle: "Spider Man No Way Home", artwork: "Movie5"),
    Movie(movieTitle: "Shang Chi", artwork: "Movie6"),
    Movie(movieTitle: "Hawkeye", artwork: "Movie7"),
]
