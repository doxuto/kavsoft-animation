//
//  Home.swift
//  SwipeActionScrollView (iOS)
//
//  Created by Balaji on 13/10/21.
//

import SwiftUI

struct Home: View {
    
    // Updating Popover Views...
    @State var graphicalDate: Bool = false
    @State var showPicker: Bool = false
    
    @State var show: Bool = false
    
    @State var placement: Placement = .leading
    
    var body: some View {
        
        NavigationView{
            
            List{
                
                Toggle(isOn: $showPicker) {
                    
                    Text("Show Picker")
                }
                
                Toggle(isOn: $graphicalDate) {
                    
                    Text("Show Graphical Date Picker")
                }
                
                Button("Change Toolbar Placement"){
                    placement = (placement == .leading ? .trailing : .leading)
                }
            }
            .navigationTitle("Popovers")
            // ToolBar...
            .toolbar {
                
                ToolbarItem(placement: placement == .leading ? .navigationBarLeading : .navigationBarTrailing) {
                    
                    Button {
                        withAnimation{
                            show.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.below.square.fill.and.square")
                    }

                }
            }
        }
        .toolBarPopover(show: $show,placement: placement) {
            
            // Showing dynamic usage...
            if showPicker{
             
                Picker(selection: .constant("")) {
                    
                    ForEach(1...10,id: \.self){index in
                        
                        Text("Hello \(index)")
                            .tag(index)
                    }
                    
                } label: {
                    
                }
                .labelsHidden()
                .pickerStyle(.wheel)
            }
            else{
                if graphicalDate{
                    // Popover View...
                    DatePicker("", selection: .constant(Date()))
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                else{
                    // Popover View...
                    DatePicker("", selection: .constant(Date()))
                        .datePickerStyle(.compact)
                        .labelsHidden()
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
