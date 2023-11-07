//
//  ExpenseViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Balaji on 20/05/22.
//

import SwiftUI

class ExpenseViewModel: ObservableObject{
    // MARK: Properties
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var currentMonthStartDate: Date = Date()
    
    // MARK: Expense/ Income Tab
    @Published var tabName: ExpenseType = .expense
    // MARK: Filter View
    @Published var showFilterView: Bool = false
    
    // MARK: New Expense Properties
    @Published var addNewExpense: Bool = false
    @Published var amount: String = ""
    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var remark: String = ""
    
    init(){
        // MARK: Fetching Current Month Starting Date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: Date())
        
        startDate = calendar.date(from: components)!
        currentMonthStartDate = calendar.date(from: components)!
    }
    
    // MARK: This is a Sample Data of Month May
    // You can Customize this Even more with Your Data (Core Data)
    @Published var expenses: [Expense] = sample_expenses
    
    // MARK: Fetching Current Month Date String
    func currentMonthDateString()->String{
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " + Date().formatted(date: .abbreviated, time: .omitted)
    }
    
    func convertExpensesToCurrency(expenses: [Expense],type: ExpenseType = .all)->String{
        var value: Double = 0
        value = expenses.reduce(0, { partialResult, expense in
            return partialResult + (type == .all ? (expense.type == .income ? expense.amount : -expense.amount) : (expense.type == type ? expense.amount : 0))
        })
        
        return convertNumberToPrice(value: value)
    }
    
    // MARK: Converting Selected Dates To String
    func convertDateToString()->String{
        return startDate.formatted(date: .abbreviated, time: .omitted) + " - " + endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    // MARK: Converting Number To Price
    func convertNumberToPrice(value: Double)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? "$0.00"
    }
    
    // MARK: Clearing All Data
    func clearData(){
        date = Date()
        type = .all
        remark = ""
        amount = ""
    }
    
    // MARK: Save Data
    func saveData(env: EnvironmentValues){
        // MARK: Do Actions Here
        print("Save")
        // MARK: This is For UI Demo
        // Replace With Core Data Actions
        let amountInDouble = (amount as NSString).doubleValue
        let colors = ["Yellow","Red","Purple","Green"]
        let expense = Expense(remark: remark, amount: amountInDouble, date: date, type: type, color: colors.randomElement() ?? "Yellow")
        withAnimation{expenses.append(expense)}
        expenses = expenses.sorted(by: { first, scnd in
            return scnd.date < first.date
        })
        env.dismiss()
    }
}
