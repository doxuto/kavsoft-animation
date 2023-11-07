//
//  Home.swift
//  Analytics (iOS)
//
//  Created by Balaji on 01/10/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        // Home View...
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 18){
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Weekly icons")
                            .font(.title.bold())
                        
                        Text("reports is available!")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer(minLength: 10)
                    
                    Button {
                        
                    } label: {
                        
                        // BUtton With Badge...
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .overlay(
                            
                                Text("2")
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 11, y: -12),
                                
                                alignment: .topTrailing
                            )
                            .offset(x: -2)
                            .padding(15)
                            .background(Color.white)
                            .clipShape(Circle())
                    }

                }
                
                // Graph View....
                BarGraph(downloads: downloads)
                
                // Users View...
                HStack(spacing: 0){
                    
                    // Progress View...
                    UserProgress(title: "New Users", color: Color("LightBlue"), image: "person", progress: 68)
                    
                    UserProgress(title: "Old Users", color: Color("Pink"), image: "person", progress: 72)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                
                // Most Downloads...
                VStack{
                    
                    HStack{
                        
                        Text("Most Downloaded icons")
                            .font(.callout.bold())
                        
                        Spacer()
                        
                        Menu {
                            
                            Button("More"){}
                            Button("Extra"){}
                            
                        } label: {
                            
                            Image("menu")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.primary)
                        }
                    }

                    HStack(spacing: 15){
                        
                        Image(systemName: "flame.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding(12)
                            .background(
                            
                                Color.gray
                                    .opacity(0.25)
                                    .clipShape(Circle())
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Fire Flame")
                                .fontWeight(.bold)
                            
                            Text("1289 Download")
                                .font(.caption2.bold())
                                .foregroundColor(.gray)
                        }
                        
                        Spacer(minLength: 10)
                        
                        Image(systemName: "square.and.arrow.down.on.square.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .padding(.top,20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func UserProgress(title: String,color: Color,image: String,progress: CGFloat)->some View{
        
        HStack{
            
            Image(systemName: image)
                .font(.title2)
                .foregroundColor(color)
                .padding(10)
                .background(
                
                    ZStack{
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.3),lineWidth: 2)
                        
                        Circle()
                            .trim(from: 0, to: progress / 100)
                            .stroke(color,lineWidth: 2)
                            .rotationEffect(.init(degrees: -90))
                    }
                )
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("\(Int(progress))%")
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption2.bold())
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
