//
//  CloudView.swift
//  FlightAppUI
//
//  Created by Balaji on 26/11/22.
//

import SwiftUI

// MARK: Cloud View
struct CloudView: View{
    var delay: Double
    var size: CGSize
    @State private var moveCloud: Bool = false
    
    var body: some View{
        ZStack{
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            /// Duration = Speed of The Movement of the Cloud
            withAnimation(.easeInOut(duration: 5.5).delay(delay)){
                moveCloud.toggle()
            }
        }
    }
}
