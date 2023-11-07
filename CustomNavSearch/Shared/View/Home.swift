//
//  Home.swift
//  CustomNavSearch (iOS)
//
//  Created by Balaji on 05/01/22.
//

import SwiftUI

struct Home: View {
    @State var barColor: Color = .init(white: 0)
    @State var barTextColor: Color = .primary
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    Text("Navigation Bar Color")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Picker(selection: $barColor) {
                        
                        // Sample Colors
                        
                        Text("Clear")
                            .tag(Color.clear)
                        
                        Text("Pink")
                            .tag(Color.pink)
                        
                        Text("Purple")
                            .tag(Color.purple)
                        
                        Text("Orange")
                            .tag(Color.orange)
                        
                        Text("Cyan")
                            .tag(Color.cyan)
                        
                    } label: {
                        
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    
                    Text("Navigation Bar Text Color")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Picker(selection: $barTextColor) {
                        
                        // Sample Colors
                        
                        Text("Primary")
                            .tag(Color.primary)
                        
                        Text("White")
                            .tag(Color.white)
                        
                        Text("Black")
                            .tag(Color.black)
                        
                        Text("Orange")
                            .tag(Color.orange)
                        
                        Text("Green")
                            .tag(Color.green)
                        
                    } label: {
                        
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    
                    // MARK: Sample Images
                    ForEach(1...11,id: \.self){index in
                        
                        NavigationLink {
                            Text("Detail View")
                                .navigationTitle("Detail")
                        } label: {
                            
                            GeometryReader{proxy in
                                
                                let size = proxy.size
                                
                                Image("Post\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .cornerRadius(10)
                            }
                            .frame(height: 180)
                        }

                    }
                }
                .padding()
            }
            .navigationTitle("Navigation View")
            .toolbar {
                Button("RESET"){
                    barColor = .init(white: 0)
                    barTextColor = .primary
                    resetNavBar()
                }
            }
            // Updating Colors
            .onChange(of: barColor) { newValue in
                if barColor == Color.init(white: 0){return}
                setNavbarColor(color: barColor)
                barTextColor = .primary
            }
            .onChange(of: barTextColor) { newValue in
                setNavbarTitleColor(color: barTextColor)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
