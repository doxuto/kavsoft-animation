//
//  Task.swift
//  PopUpNavigation (iOS)
//
//  Created by Balaji on 17/01/22.
//

import SwiftUI

// MARK: Task Model
struct Task: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
}

// MARK: Sample Tasks
var tasks: [Task] = [

    Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day"),
    Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week"),
    Task(taskTitle: "Prototype", taskDescription: "Make and send prototype"),
    Task(taskTitle: "Check asset", taskDescription: "Start checking the assets"),
    Task(taskTitle: "Team party", taskDescription: "Make fun with team mates"),
    Task(taskTitle: "Client Meeting", taskDescription: "Explain project to clinet"),
    
    Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team"),
    Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal"),
]
