//
//  Home.swift
//  ExpenseTracker (iOS)
//
//  Created by Balaji on 20/05/22.
//

import SwiftUI

struct Home: View {
    @StateObject var expenseViewModel: ExpenseViewModel = .init()
    // MARK: Spotlight Properties
    @State var showSpotlight: Bool = false
    @State var currentSpot: Int = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12){
                HStack(spacing: 15){
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome!")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("iJustine")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    NavigationLink {
                        FilteredDetailView()
                            .environmentObject(expenseViewModel)
                    } label: {
                        Image(systemName: "hexagon.fill")
                            .foregroundColor(.gray)
                            .overlay(content: {
                                Circle()
                                    .stroke(.white,lineWidth: 2)
                                    .padding(7)
                            })
                            .frame(width: 40, height: 40)
                            .background(Color.white,in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
                    .addSpotlight(0, shape: .rounded, roundedRadius: 10, text: "Expenses Filtering")
                }
                ExpenseCard()
                    .environmentObject(expenseViewModel)
                TransactionsView()
            }
            .padding()
        }
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $expenseViewModel.addNewExpense) {
            expenseViewModel.clearData()
        } content: {
            NewExpense()
                .environmentObject(expenseViewModel)
        }
        .overlay(alignment: .bottomTrailing) {
            AddButton()
        }
        .addSpotlightOverlay(show: $showSpotlight, currentSpot: $currentSpot)
        .onAppear {
            showSpotlight = true
        }
    }
    
    // MARK: Add New Expense Button
    @ViewBuilder
    func AddButton()->some View{
        Button {
            expenseViewModel.addNewExpense.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background{
                    Circle()
                        .fill(
                            .linearGradient(colors: [
                                Color("Gradient1"),
                                Color("Gradient2"),
                                Color("Gradient3"),
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
        }
        .addSpotlight(3, shape: .circle, text: "Adding New Expense\nTo the App!")
        .padding()
    }
    
    // MARK: Transactions View
    @ViewBuilder
    func TransactionsView()->some View{
        VStack(spacing: 15){
            Text("Transactions")
                .font(.title2.bold())
                .opacity(0.7)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.bottom)
            
            ForEach(expenseViewModel.expenses){expense in
                // MARK: Transaction Card View
                // MARK: Showing Spotlight For First Card
                if expense.id == expenseViewModel.expenses.first?.id{
                    TransactionCardView(expense: expense)
                        .environmentObject(expenseViewModel)
                        .addSpotlight(2, shape: .rounded, roundedRadius: 15, text: "Transcation Details")
                }else{
                    TransactionCardView(expense: expense)
                        .environmentObject(expenseViewModel)
                }
            }
        }
        .padding(.top)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
