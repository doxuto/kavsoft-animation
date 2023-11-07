//
//  Link.swift
//  AdvancedScroll (iOS)
//
//  Created by Balaji on 26/12/21.
//

import SwiftUI

// Sample Links
struct Link: Identifiable{
    
    var id = UUID().uuidString
    var title: String
    var logo: String
}

var links = [

    Link(title: "Tumblr", logo: "tumblr"),
    Link(title: "Twitter", logo: "twitter"),
    Link(title: "Instagram", logo: "instagram"),
    Link(title: "Google", logo: "google"),
    Link(title: "Dribbble", logo: "dribbble"),
    Link(title: "Pinterest", logo: "pinterest"),
]
