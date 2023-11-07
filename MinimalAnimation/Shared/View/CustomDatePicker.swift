//
//  CustomDatePicker.swift
//  ElegantTaskApp (iOS)
//
//  Created by Balaji on 28/09/21.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    // Month update on arrow button clicks...
    @State var currentMonth: Int = 0
    // MARK: Animated States
    @State var animatedStates: [Bool] = Array(repeating: false, count: 2)
    
    var body: some View {
        
        // Updating it for our Usage
        VStack(spacing: 15){
            
            HStack(spacing: 20){
                
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                
                Text(extraDate()[0] + " " + extraDate()[1])
                    .font(.callout)
                    .fontWeight(.semibold)

                Button {
                    
                    withAnimation{
                        currentMonth += 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .opacity(animatedStates[0] ? 1 : 0)
            
            Rectangle()
                .fill(.white.opacity(0.4))
                .frame(width: animatedStates[0] ? nil : 0,height: 1)
                .padding(.vertical,4)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            // Dates....
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            if animatedStates[0]{
                LazyVGrid(columns: columns,spacing: 20) {
                    
                    ForEach(0..<extractDate().count,id: \.self){index in
                        
                        let value = extractDate()[index]
                        PickerCardView(value: value, index: index, currentDate: $currentDate,isFinished: $animatedStates[1])
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
            }
            // To Avoid this
            else{
                LazyVGrid(columns: columns,spacing: 20) {
                    
                    ForEach(extractDate().indices){index in
                        
                        let value = extractDate()[index]
                        PickerCardView(value: value, index: index, currentDate: $currentDate,isFinished: $animatedStates[1])
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
                .opacity(0)
            }
        }
        .padding()
        .onChange(of: currentMonth) { newValue in
            
            // updating Month...
            currentDate = getCurrentMonth()
        }
        .onAppear {
            // Animating View with some Delay
            // Delay for Splash Animation to Sync with the Current one
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3)){
                    animatedStates[0] = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animatedStates[1] = true
                }
            }
        }
    }
    // extrating Year And Month for display...
    func extraDate()->[String]{
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate) - 1
        let year = calendar.component(.year, from: currentDate)
        
        return ["\(year)",calendar.monthSymbols[month]]
    }
    
    func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        // Getting Current Month Date....
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
                
        return currentMonth
    }
    
    func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        // Getting Current Month Date....
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            // getting day...
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first!.date)
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

// Global Method
func isSameDay(date1: Date,date2: Date)->Bool{
    let calendar = Calendar.current
    
    return calendar.isDate(date1, inSameDayAs: date2)
}

// Card View
// Since we need a @State Variables for each Card View
struct PickerCardView: View{
    var value: DateValue
    var index: Int
    @Binding var currentDate: Date
    @Binding var isFinished: Bool
    // Animating View
    @State var showView: Bool = false
    
    var body: some View{
        
        VStack{
            
            if value.day != -1{
                
                Text("\(value.day)")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .black : .white)
                    .frame(maxWidth: .infinity)
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(.white)
                .padding(.vertical,-5)
                .padding(.horizontal,5)
                .opacity(isSameDay(date1: currentDate, date2: value.date) ? 1 : 0)
        }
        .opacity(showView ? 1 : 0)
        .onAppear {
            // Since every time month changed its animating
            // Stopping it for only First Time
            if isFinished{showView = true}
            withAnimation(.spring().delay(Double(index) * 0.02)){
                showView = true
            }
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extending Date to get Current Month Dates...
extension Date{
    
    func getAllDates()->[Date]{
        
        let calendar = Calendar.current
        
        // getting start Date...
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date...
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
