//
//  HoneyCombGridView.swift
//  QuizGame (iOS)
//
//  Created by Balaji on 14/02/22.
//

import SwiftUI

// MARK: Building Custom Foreach Builder for Honey Comb Grid View
// Note: You can also pass KeyPath ID Here
// Like: KeyPath<Item.Element, ID>
struct HoneyCombGridView<Content: View,Item>: View where Item: RandomAccessCollection {
    
    var content: (Item.Element)->Content
    var items: Item
    
    init(items: Item,@ViewBuilder content: @escaping (Item.Element)->Content){
        self.content = content
        self.items = items
    }
    
    @State var width: CGFloat = 0
    
    var body: some View {
        
        // Note: Why we're not using Geometry Reader Here?
        // Bcz It will not work on ScrollView, if your view has no scrollView then you can skip this step
        
        // Removing Hexagon Top Radius
        VStack(spacing: -20){
            
            ForEach(setUpHoneyCombGrid().indices,id: \.self){index in
                
                HStack(spacing: 4){
                    
                    ForEach(setUpHoneyCombGrid()[index].indices,id: \.self){subIndex in
                        
                        content(setUpHoneyCombGrid()[index][subIndex])
                        // Maintaining Proper Width
                            .frame(width: (width) / 4)
                            .offset(x: setOffset(index: index))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(name: "HoneyComb")
        .overlay {
            GeometryReader{proxy in
                Color.clear
                    .preference(key: WidthKey.self, value: proxy.frame(in: .named("HoneyComb")).width - proxy.frame(in: .named("HoneyComb")).minX)
                    .onPreferenceChange(WidthKey.self) { width in
                        self.width = width
                    }
            }
        }
    }
    
    // To Avoid Unoriented Grids
    func setOffset(index: Int)->CGFloat{
        let current = setUpHoneyCombGrid()[index].count
        let offset = (width / 4) / 2
        
        if index != 0{
            
            let previous = setUpHoneyCombGrid()[index - 1].count
            
            if current == 1 && previous % 2 == 0{
                return 0
            }
            
            if previous % current == 0{
                return -offset - 2
            }
        }
        
        return 0
    }
    
    // Generating HoneyComb Grids
    // Honey Comb Pattern will be
    // 4,3,4,3.....
    func setUpHoneyCombGrid()->[[Item.Element]]{
        var rows: [[Item.Element]] = []
        var itemsAtRow: [Item.Element] = []
        
        // For Maintaining Count
        var count: Int = 0
        
        items.forEach { item in
            itemsAtRow.append(item)
            count += 1
            
            if itemsAtRow.count >= 3{
                
                // Checking if its empty and first row is always 4
                if rows.isEmpty && itemsAtRow.count == 4{
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
                // If Previous Row contains 4 items then current will be 3
                // Otherwise viceversa
                else if let last = rows.last,last.count == 4 && itemsAtRow.count == 3{
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
                else if let last = rows.last,last.count == 3 && itemsAtRow.count == 4{
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
            }
            
            // Checking Exhaust Items
            if count == items.count{
                if let last = rows.last{
                    
                    // Checking if the previous Row has some Vacant
                    // Also checking the order i.e: 4,3,4...
                    if rows.count >= 2{
                        let previous = (rows[rows.count - 2].count == 4 ? 3 : 4)
                        
                        if (last.count + itemsAtRow.count) <= previous{
                            rows[rows.count - 1].append(contentsOf: itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                        else{
                            rows.append(itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                    }
                    else{
                        if (last.count + itemsAtRow.count) <= 4{
                            rows[rows.count - 1].append(contentsOf: itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                        else{
                            rows.append(itemsAtRow)
                            itemsAtRow.removeAll()
                        }
                    }
                }
                else{
                    // Appeding Row
                    rows.append(itemsAtRow)
                    itemsAtRow.removeAll()
                }
            }
        }
        
        return rows
    }
}

struct HoneyCombGridView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Width Preference Key
struct WidthKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
