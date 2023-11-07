//
//  Task.swift
//  DragDropLists
//
//  Created by Balaji on 18/07/23.
//

import SwiftUI

struct Task: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var status: Status
}

enum Status {
    case todo
    case working
    case completed
}
