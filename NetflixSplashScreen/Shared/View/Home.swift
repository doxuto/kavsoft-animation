//
//  Home.swift
//  NetflixSplashScreen
//
//  Created by Balaji on 04/10/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        VStack{
            
            HStack(spacing: 12){
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 30)
                
                Spacer()
                
                Button("Help"){
                    
                }
                Button("Privacy"){
                    
                }
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.primary)
            
            Image("onboard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .padding(.top,30)
            
            Text("Watch on any device")
                .font(.title.bold())
                .padding(.top,25)
            
            Text("Stream on your phone, tablet,\nlaptop, TV.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top,18)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("SIGN IN")
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .frame(maxWidth: .infinity)
                    .background(Color("Red"))
            }

        }
        .padding()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
