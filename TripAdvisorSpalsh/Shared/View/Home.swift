//
//  Home.swift
//  TripAdvisorSpalsh (iOS)
//
//  Created by Balaji on 19/12/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    // Sample Images...
                    ForEach(1...6,id: \.self){index in
                        
                        GeometryReader{proxy in
                            
                            let size = proxy.size
                            
                            Image("Post\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width,height: size.height)
                                .cornerRadius(15)
                        }
                        .frame(height: 250)
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
