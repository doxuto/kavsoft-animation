//
//  Home.swift
//  ThumbnailVideoScroller (iOS)
//
//  Created by Balaji on 20/02/22.
//

import SwiftUI

struct Home: View {
    // Cover Image Properties
    @State var currentCoverImage: UIImage?
    @State var progress: CGFloat = 0
    @State var url = URL(fileURLWithPath: Bundle.main.path(forResource: "Test2", ofType: "mp4") ?? "")
    var body: some View {
        VStack{
            VStack {
                HStack{
                    
                    Button {
                        
                    } label: {
                     
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    NavigationLink("Done") {
                        if let currentCoverImage = currentCoverImage {
                            Image(uiImage: currentCoverImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 300)
                                .cornerRadius(15)
                        }
                    }
                }
                .overlay {
                    Text("Cover")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding([.horizontal,.bottom])
                .padding(.top,10)
                
                Divider()
                    .background(Color.black.opacity(0.6))
            }
            .frame(maxHeight: .infinity,alignment: .top)
            
            // MARK: Current Cover Image
            GeometryReader{proxy in
                let size = proxy.size
                
                ZStack{
                    // Custom Video Player will show the preview
                    PreviewPlayer(url: $url, progress: $progress)
                        .cornerRadius(15)
                }
                .frame(width: size.width, height: size.height)
            }
            .frame(width: 200,height: 300)
            
            Text("To select a cover image, choose a from\nyour video or an image from your camera roll.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical,30)
            
            // MARK: Cover Image Scroller
            // Pass your URL Here
            // Your Cover Image Size
            let size = CGSize(width: 400, height: 400)
            VideoCoverScroller(videoURL: $url, progress: $progress,imageSize: size,coverImage: $currentCoverImage)
                .padding(.top,50)
                .padding(.horizontal,15)
            
            Button {
                
            } label: {
             
                Label {
                    Text("Add From Camera Roll")
                } icon: {
                 
                    Image(systemName: "plus.square")
                        .font(.title2)
                }
                .foregroundColor(.primary)
            }
            .padding(.vertical)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
