//
//  Home.swift
//  TaskManagement (iOS)
//
//  Created by Balaji on 08/01/22.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    // MARK: Edit Button Context
    @Environment(\.editMode) var editButton
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: Active Week View
                    HStack(spacing: 0){
                        Button(action: taskModel.backwardToLastWeek) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .contentShape(Rectangle())
                        }
                        .offset(x: -5,y: -5)
                        .disabled(taskModel.isCurrentWeekContainsToday)
                        .opacity(taskModel.isCurrentWeekContainsToday ? 0.4 : 1)
                        
                        ForEach(taskModel.currentWeek,id: \.self){day in
                            VStack(spacing: 10){
                                Text(taskModel.extractDate(date: day, format: "MMM"))
                                    .font(.system(size: 12))
                                
                                Text(taskModel.extractDate(date: day, format: "dd"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                
                                // EEE will return day as MON,TUE,....etc
                                Text(taskModel.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 14))
                                
                                if taskModel.isToday(date: day) {
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 8, height: 8)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                } else {
                                    Circle()
                                        .fill(.clear)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            // MARK: Foreground Style
                            .foregroundColor(taskModel.isToday(date: day) ? .black : .gray)
                            // MARK: Capsule Shape
                            .frame(width: 45, height: 90)
                            .contentShape(Capsule())
                            .onTapGesture {
                                // Updating Current Day
                                withAnimation{
                                    taskModel.currentDay = day
                                }
                            }
                            .hCenter()
                        }
                        
                        Button(action: taskModel.forwardToNextWeek) {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .contentShape(Rectangle())
                        }
                        .offset(x: 5,y: -5)
                    }
                    .padding(.horizontal)
                    
                    TasksView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        // MARK: Add Button
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black,in: Circle())
            })
            .padding()
        })
        .sheet(isPresented: $taskModel.addNewTask) {
            // Clearing Edit Data
            taskModel.editTask = nil
        } content: {
            NewTask()
                .environmentObject(taskModel)
        }
    }
    
    // MARK: Tasks View
    @ViewBuilder
    func TasksView()->some View{
        LazyVStack(spacing: 20){
            // Converting object as Our Task Model
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    // MARK: Task Card View
    @ViewBuilder
    func TaskCardView(task: Task)->some View{
        // MARK: Since CoreData Values will Give Optinal data
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top,spacing: 30){
            // If Edit mode enabled then showing Delete Button
            if editButton?.wrappedValue == .active{
                // Edit Button for Current and Future Tasks
                VStack(spacing: 10){
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        
                        Button {
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        // MARK: Deleting Task
                        context.delete(task)
                        
                        // Saving
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            }
            else{
                VStack(spacing: 10){
                    Circle()
                        .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? (task.isCompleted ? .green : .black) : .clear)
                        .frame(width: 15, height: 15)
                        .background {
                            Circle()
                                .stroke(.black,lineWidth: 1)
                                .padding(-3)
                        }
                        .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 3)
                }
            }
            
            VStack{
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()){
                    // MARK: Team Members
                    HStack(spacing: 12){
                        // MARK: Check Button
                        if !task.isCompleted{
                            Button {
                                // MARK: Updating Task
                                task.isCompleted = true
                                
                                // Saving
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white,in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundColor(task.isCompleted ? .gray : .white)
                            .hLeading()
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom,taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background {
                Color("Black")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            }
        }
        .hLeading()
    }
    
    // MARK: Header
    func HeaderView()->some View{
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            // MARK: Edit Button
            EditButton()
        }
        .padding()
        .padding(.top,getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
