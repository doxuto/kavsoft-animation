//
//  TaskModel.swift
//  InteractiveWidget
//
//  Created by Balaji on 11/06/23.
//

import SwiftUI

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCompleted: Bool = false
    
    /// Other Properties
}

/// Sample Data Model
class TaskDataModel {
    static let shared = TaskDataModel()
    
    var tasks: [TaskModel] = [
        .init(id: "DCA3F998-D07C-41F6-81BE-F7238E59C50E", taskTitle: "Record Video!"),
        .init(id: "72E985A0-9C3E-4027-AC9D-68586189E91E", taskTitle: "Edit Video"),
        .init(id: "D6CE91B9-77C8-4A3A-A889-A240830B8D50", taskTitle: "Publish it")
    ]
}
