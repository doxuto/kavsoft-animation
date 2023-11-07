//
//  Home.swift
//  ImageColorPicker (iOS)
//
//  Created by Balaji on 30/01/22.
//

import SwiftUI

struct Home: View {
    // MARK: Image Color Picker Values
    @State var showPicker: Bool = false
    @State var selectedColor: Color = .white
    var body: some View {
        ZStack{
            Rectangle()
                .fill(selectedColor)
                .ignoresSafeArea()
            
            // MARK: Picker Button
            Button {
                showPicker.toggle()
            } label: {
                Text("Show Image Color Picker")
                    .foregroundColor(selectedColor.isDarkColor ? .white : .black)
            }
        }
        // MARK: Calling Modifier
        .imageColorPicker(showPicker: $showPicker, color: $selectedColor)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
