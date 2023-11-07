//
//  Home.swift
//  SwiftUIRealm (iOS)
//
//  Created by Balaji on 24/12/21.
//

import SwiftUI
import RealmSwift

struct Home: View {
    // MARK: Read Data
    // Sorting By Date
    @ObservedResults(TaskItem.self, sortDescriptor: SortDescriptor.init(keyPath: "taskDate", ascending: false)) var tasksFetched
    
    // Opening keyboard for Newly added Task
    @State var lastAddedTaskID: String = ""
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                if tasksFetched.isEmpty{
                    
                    Text("Add some new Tasks!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                else{
                    List{
                        
                        ForEach(tasksFetched){task in
                            TaskRow(task: task,lastAddedTaskID: $lastAddedTaskID)
                            // MARK: Delete Data
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    
                                    Button(role: .destructive) {
                                        $tasksFetched.remove(task)
                                    } label: {
                                        Image(systemName: "trash")
                                    }

                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .animation(.easeInOut, value: tasksFetched)
                }
            }
            .navigationTitle("Task's")
            .toolbar {
                
                Button {
                    // MARK: Create Task
                    let task = TaskItem()
                    lastAddedTaskID = task.id.stringValue
                    $tasksFetched.append(task)
                } label: {
                    Image(systemName: "plus")
                }
            }
            // MARK: Observing Keyboard
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                
                lastAddedTaskID = ""
                guard let last = tasksFetched.last else{
                    return
                }
                
                if last.taskTitle == ""{
                    // Removing task
                    $tasksFetched.remove(last)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TaskRow: View{
    @ObservedRealmObject var task: TaskItem
    
    @Binding var lastAddedTaskID: String
    
    // MARK: Keyboard Focus
    @FocusState var showKeyboard: Bool
    var body: some View{
        
        HStack(spacing: 15){
            
            // MARK: Task Status Indicator Menu
            Menu {
                // MARK: Update Data
                Button("Missed"){
                    $task.taskStatus.wrappedValue = .missed
                }
                Button("Completed"){
                    $task.taskStatus.wrappedValue = .completed
                }
            } label: {
             
                Circle()
                    .stroke(.gray)
                    .frame(width: 15, height: 15)
                    .overlay(
                    
                        Circle()
                            .fill(task.taskStatus == .missed ? .red : (task.taskStatus == .pending ? .yellow : .green))
                    )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                
                // MARK: Task Title
                TextField("Refresh Kavsoft", text: $task.taskTitle)
                    .focused($showKeyboard)
                
                // MARK: Task Date
                if task.taskTitle != ""{
                    Picker(selection: .constant("")) {
                        
                        DatePicker(selection: $task.taskDate, displayedComponents: .date) {
                            
                        }
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .navigationTitle("Task Date")
                        
                    } label: {
                        
                        HStack{
                            Image(systemName: "calendar")
                            
                            Text(task.taskDate.formatted(date: .abbreviated, time: .omitted))
                        }
                    }

                }
            }
        }
        .onAppear {
            if lastAddedTaskID == task.id.stringValue{
                showKeyboard.toggle()
            }
        }
    }
}
