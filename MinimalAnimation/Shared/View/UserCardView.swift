//
//  UserCardView.swift
//  TaskAnimation (iOS)
//
//  Created by Balaji on 01/03/22.
//

import SwiftUI

struct UserCardView: View {
    var user: User
    var index: Int
    // Animation State
    @State var showView: Bool = false
    var body: some View {
        HStack(spacing: 12){
            Image(user.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .fontWeight(.bold)
                
                Text(user.type)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            Text(user.amount)
                .font(.title3.bold())
                .foregroundColor(user.color)
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        .background{
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(.gray.opacity(0.2),lineWidth: 1)
        }
        .offset(y: index > 8 ? 0 : showView ? 0 : 650)
        .onAppear {
            if index > 8{return}
            // Animating View
            withAnimation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1)){
                showView = true
            }
        }
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
