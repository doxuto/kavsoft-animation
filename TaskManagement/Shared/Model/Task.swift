//
//  Task.swift
//  TaskManagement (iOS)
//
//  Created by Balaji on 08/01/22.
//

import SwiftUI

// Task Model
struct Task: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
