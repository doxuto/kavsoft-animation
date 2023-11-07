//
//  Home.swift
//  PinchtoZoom (iOS)
//
//  Created by Balaji on 21/12/21.
//

import SwiftUI

struct Home: View {
    @SceneStorage("isZooming") var isZooming: Bool = false
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
        
            VStack(spacing: 18){

                ForEach(1...5,id: \.self){index in
                    
                    Image("Post\(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: getRect().width - 30, height: 250)
                        .cornerRadius(15)
                        .addPinchZoom()
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .top) {
            
            HStack{
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "camera.fill")
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "paperplane.fill")
                }

            }
            .overlay(
            
                Text("Instagram")
                    .font(.title3.bold())
            )
            .padding()
            .foregroundColor(.primary)
            .background(.ultraThinMaterial)
            // Hiding Nav Bar...
            .offset(y: isZooming ? -200 : 0)
            .animation(.easeInOut, value: isZooming)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// extending view to get Screen Bounds...
extension View{
    
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
