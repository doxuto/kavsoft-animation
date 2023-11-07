//
//  Task.swift
//  TaskPlanner
//
//  Created by Balaji on 04/01/23.
//

import SwiftUI

// MARK: Task Model
struct Task: Identifiable{
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskDescription: String
    var taskCategory: Category
}

/// - Sample Tasks
var sampleTasks: [Task] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Edit YT Video", taskDescription: "", taskCategory: .general),
    .init(dateAdded: Date(timeIntervalSince1970: 1672833409), taskName: "Matched Geometry Effect(Issue)", taskDescription: "", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1672833409), taskName: "Multi-ScrollView", taskDescription: "", taskCategory: .challenge),
    .init(dateAdded: Date(timeIntervalSince1970: 1672837009), taskName: "Loreal Ipsum", taskDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.", taskCategory: .idea),
    .init(dateAdded: Date(timeIntervalSince1970: 1672714609), taskName: "Complete UI Animation Challenge", taskDescription: "", taskCategory: .challenge),
    .init(dateAdded: Date(timeIntervalSince1970: 1672851409), taskName: "Fix Shadow issue on Mockup's", taskDescription: "", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1672901809), taskName: "Add Shadow Effect in Mockview App", taskDescription: "", taskCategory: .idea),
    .init(dateAdded: Date(timeIntervalSince1970: 1672901809), taskName: "Twitter/Instagram Post", taskDescription: "", taskCategory: .general),
    .init(dateAdded: Date(timeIntervalSince1970: 1672923409), taskName: "Lorem Ipsum", taskDescription: "", taskCategory: .modifiers),
]
