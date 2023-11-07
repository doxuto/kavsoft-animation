//
//  Home.swift
//  SimpleTodo
//
//  Created by Balaji on 02/06/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @Environment(\.self) private var env
    @State private var filterDate: Date = .init()
    @State private var showPendingTasks: Bool = true
    @State private var showCompletedTasks: Bool = true
    var body: some View {
        List {
            DatePicker(selection: $filterDate, displayedComponents: [.date]) {

            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            CustomFilteringDataView(filterDate: $filterDate) { pendingTasks, completedTasks in
                DisclosureGroup(isExpanded: $showPendingTasks) {
                    /// Custom Core Data Filter View, Which will Display Only Pending Tasks on this Day
                    if pendingTasks.isEmpty {
                        Text("No Task's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(pendingTasks) {
                            TaskRow(task: $0, isPendingTask: true)
                        }
                    }
                } label: {
                    Text("Pending Task's \(pendingTasks.isEmpty ? "" : "(\(pendingTasks.count))")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                DisclosureGroup(isExpanded: $showCompletedTasks) {
                    /// Custom Core Data Filter View, Which will Display Only Completed Tasks on this Day
                    if completedTasks.isEmpty {
                        Text("No Task's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(completedTasks) {
                            TaskRow(task: $0, isPendingTask: false)
                        }
                    }
                } label: {
                    Text("Completed Task's \(completedTasks.isEmpty ? "" : "(\(completedTasks.count))")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    /// Simply Opening Pending Task View
                    /// Then Adding an Empty Task
                    do {
                        let task = Task(context: env.managedObjectContext)
                        task.id = .init()
                        task.date = filterDate
                        task.title = ""
                        task.isCompleted = false
                        
                        try env.managedObjectContext.save()
                        showPendingTasks = true
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        
                        Text("New Task")
                    }
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    var newTaskPlacement: ToolbarItemPlacement {
        #if os(macOS)
        return ToolbarItemPlacement.secondaryAction
        #else
        return ToolbarItemPlacement.bottomBar
        #endif
    }
}
