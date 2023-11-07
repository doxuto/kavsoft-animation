//
//  Message.swift
//  ElasticScroll
//
//  Created by Balaji on 28/05/23.
//

import SwiftUI

/// Message Model
struct Message: Identifiable {
    var id: UUID = .init()
    var image: String
    var name: String
    var message: String
    var online: Bool
    var read: Bool
}

let sampleMessages: [Message] = [
    .init(
    image: "Pic 1",
    name: "iJustine",
    message: "Hi, What's up?",
    online: true,
    read: false
    ),
    .init(
    image: "Pic 2",
    name: "Miranda",
    message: "How are you doing?",
    online: false,
    read: false
    ),
    .init(
    image: "Pic 3",
    name: "Jenna",
    message: "Don't Waste Time...",
    online: false,
    read: true
    ),
    .init(
    image: "Pic 4",
    name: "Emily",
    message: "Playing Mass Effect",
    online: true,
    read: true
    ),
    .init(
    image: "Pic 5",
    name: "Andri",
    message: "Justine told me to..",
    online: false,
    read: false
    ),
    .init(
    image: "Pic 6",
    name: "Emma",
    message: "I mean we definitely could",
    online: true,
    read: true
    ),
    .init(
    image: "Pic 7",
    name: "Jennifer",
    message: "Have you ever tried surfing?",
    online: true,
    read: false
    ),
    .init(
    image: "Pic 8",
    name: "Maciej Miranda",
    message: "Danny is incredibly funny!!",
    online: false,
    read: true
    ),
    .init(
    image: "Pic 9",
    name: "Zara Osborne",
    message: "How are you doing?",
    online: true,
    read: true
    ),
    .init(
    image: "Pic 10",
    name: "Rui Black",
    message: "Are we able to delivery in time?",
    online: false,
    read: true
    ),
    .init(
    image: "Pic 11",
    name: "Yazmin Pate",
    message: "For sure! Consistency is key.",
    online: false,
    read: true
    ),
   .init(
    image: "Pic 12",
    name: "Kristina Martins",
    message: "Like Casey Neistat?",
    online: true,
    read: false
    ),
    .init(
    image: "Pic 13",
    name: "Ryan Buckner",
    message: "At this point, I am not suprised",
    online: false,
    read: true
    ),
    .init(
    image: "Pic 14",
    name: "Amna Partridge",
    message: "Tomorrow, we are ✈️✈️",
    online: false,
    read: false
    ),
    .init(
    image: "Pic 15",
    name: "Paris Kirby",
    message: "I am running out of ideas..",
    online: true,
    read: true
    ),
]
