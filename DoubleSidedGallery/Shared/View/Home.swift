//
//  Home.swift
//  DoubleSidedGallery (iOS)
//
//  Created by Balaji on 11/10/21.
//

import SwiftUI

struct Home: View {
    
    // Posts...
    @State var posts: [Post] = []
    
    // Current Image...
    @State var currentPost: String = ""
    
    @State var fullPreview: Bool = false
    
    var body: some View {
        
        // Double Side Gallery....
        TabView(selection: $currentPost) {
            
            ForEach(posts){post in
                
                // For Getting Screen Size for Image...
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    Image(post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(0)
                }
                .tag(post.id)
                .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation{
                fullPreview.toggle()
            }
        }
        // Top DetailView...
        .overlay(
        
            HStack{
                
                Text("Scenario Pic's")
                    .font(.title2.bold())
                    
                Spacer(minLength: 0)
                
                Button{
                    
                } label: {
                    
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                }
                
            }
                .foregroundColor(.white)
                .padding()
                .background(BlurView(style: .systemUltraThinMaterialDark).ignoresSafeArea())
            // Hiding Both top and bottom Bars...
                .offset(y: fullPreview ? -150 : 0),
            
            alignment: .top
        )
        // Bottom Images View...
        .overlay(
        
            // SCrollView reader to navigate to current Image...
            ScrollViewReader{proxy in
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 15){
                        
                        ForEach(posts){post in
                            
                            Image(post.postImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 60)
                                .cornerRadius(12)
                            // Showing Ring for Current Post...
                                .padding(2)
                                .overlay(
                                
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white,lineWidth: 2)
                                        .opacity(currentPost == post.id ? 1 : 0)
                                )
                                .id(post.id)
                                .onTapGesture {
                                    withAnimation{
                                        currentPost = post.id
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .frame(height: 80)
                .background(BlurView(style: .systemUltraThinMaterialDark).ignoresSafeArea())
                // While CurrentPost changing moving the current image view to center of scrollview...
                .onChange(of: currentPost) { _ in
                    
                    withAnimation{
                        proxy.scrollTo(currentPost, anchor: .bottom)
                    }
                }
            }
            .offset(y: fullPreview ? 150 : 0),
            
            alignment: .bottom
        )
        // Inserting Sample Post Images...
        .onAppear {
            for index in 1...10{
                posts.append(Post(postImage: "post\(index)"))
            }
            
            currentPost = posts.first?.id ?? ""
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
