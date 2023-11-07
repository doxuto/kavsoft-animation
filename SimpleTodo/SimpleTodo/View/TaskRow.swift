//
//  TaskRow.swift
//  SimpleTodo
//
//  Created by Balaji on 03/06/23.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    var isPendingTask: Bool
    /// View Properties
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    var body: some View {
        HStack(spacing: 12) {
            Button {
                task.isCompleted.toggle()
                save()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                TextField("Task Title", text: .init(get: {
                    return task.title ?? ""
                }, set: { value in
                    task.title = value
                }))
                .focused($showKeyboard)
                .onSubmit {
                    removeEmptyTask()
                    save()
                }
                .foregroundColor(isPendingTask ? .primary : .gray)
                .strikethrough(!isPendingTask, pattern: .solid, color: .primary)
                
                /// Custom Date Picker
                Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .foregroundColor(.gray)
                    .overlay {
                        DatePicker(selection: .init(get: {
                            return task.date ?? .init()
                        }, set: { value in
                            task.date = value
                            /// Saving Date When ever it's Updated
                            save()
                        }), displayedComponents: [.hourAndMinute]) {
                            
                        }
                        .labelsHidden()
                        /// Hiding View by Utilizing BlendMode Modifier
                        .blendMode(.destinationOver)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            if (task.title ?? "").isEmpty {
                showKeyboard = true
            }
        }
        .onDisappear {
            removeEmptyTask()
            save()
        }
        /// Verifiying Content when user leaves the App
        .onChange(of: env.scenePhase) { newValue in
            if newValue != .active {
                showKeyboard = false
                DispatchQueue.main.async {
                    /// Checking if it's Empty
                    removeEmptyTask()
                    save()
                }
            }
        }
        /// Adding Swipe to Delete
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    env.managedObjectContext.delete(task)
                    save()
                }
            } label: {
                Image(systemName: "trash.fill")
            }
        }
    }
    
    /// Context Saving Method
    func save() {
        do {
            try env.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Removing Empty Task
    func removeEmptyTask() {
        if (task.title ?? "").isEmpty {
            /// Removing Empty Task
            env.managedObjectContext.delete(task)
        }
    }
}
