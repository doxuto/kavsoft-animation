//
//  TaskViewModel.swift
//  TaskManagement (iOS)
//
//  Created by Balaji on 08/01/22.
//

import SwiftUI

class TaskViewModel: ObservableObject{
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    // MARK: Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    // MARK: New Task View
    @Published var addNewTask: Bool = false
    // MARK: Edit Data
    @Published var editTask: Task?
    
    // MARK: Intializing
    init(){
        fetchWeek()
    }
    
    func fetchWeek(_ start: Date = .init()){
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: start)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        currentWeek = []
        (0..<7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    func forwardToNextWeek() {
        let calendar = Calendar.current
        if let lastWeekDay = currentWeek.last, let nextWeekStartDay = calendar.date(byAdding: .day, value: 1, to: lastWeekDay) {
            withAnimation(.easeInOut(duration: 0.3)) {
                fetchWeek(nextWeekStartDay)
                currentDay = nextWeekStartDay
            }
        }
    }
    
    func backwardToLastWeek() {
        let calendar = Calendar.current
        if let firstWeekDay = currentWeek.first, let lastWeekStartDay = calendar.date(byAdding: .day, value: -7, to: firstWeekDay) {
            withAnimation(.easeInOut(duration: 0.3)) {
                fetchWeek(lastWeekStartDay)
                currentDay = lastWeekStartDay
                
                if let day = currentWeek.first(where: { day in
                    calendar.isDateInToday(day)
                }) {
                    currentDay = day
                }
            }
        }
    }
    
    var isCurrentWeekContainsToday: Bool {
        let calendar = Calendar.current
        
        return currentWeek.contains { day in
            calendar.isDateInToday(day)
        }
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date,format: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current Date is Today
    func isToday(date: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date)->Bool{
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currentHour && isToday)
    }
}
