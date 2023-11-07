//
//  Home.swift
//  SplashsAnimation (iOS)
//
//  Created by Balaji on 17/10/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 20){
                    
                    ForEach(1...5,id: \.self){index in
                        
                        Image("Pic\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getRect().width - 30, height: 220)
                            .cornerRadius(15)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Trending Posts")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
