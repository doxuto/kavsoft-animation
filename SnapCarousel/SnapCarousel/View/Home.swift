//
//  Home.swift
//  SnapCarousel
//
//  Created by Balaji on 10/02/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var images: [ImageFile] = []
    @State private var index: Int = 0
    @State private var previewImage: UIImage?
    var body: some View {
        VStack(spacing: 0) {
            /// Header View
            Text("GALLERY")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding([.horizontal, .bottom], 15)
                .padding(.top, 10)
            
            GeometryReader {
                let size = $0.size
                
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .onChange(of: index) { newValue in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.previewImage = UIImage(named: images[newValue].imageName)
                            }
                        }
                }
            }
            .padding(.vertical, 15)
            
            /// Snap Interval Carousel
            GeometryReader {
                let size = $0.size
                let pageWidth: CGFloat = size.width / 3
                let imageWidth: CGFloat = 100
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(images) { imageFile in
                            ZStack {
                                if let thumbnail = imageFile.thumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageWidth, height: size.height)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                            }
                            .frame(width: pageWidth, height: size.height)
                        }
                    }
                    /// Making to Start from the Center
                    .padding(.horizontal, (size.width - pageWidth) / 2)
                    .background {
                        SnapCarouselHelper(pageWidth: pageWidth, pageCount: images.count, index: $index)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.white, lineWidth: 3.5)
                        .frame(width: imageWidth, height: size.height)
                        /// Disabling User Interaction's
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 120)
            .padding(.bottom, 10)
        }
        .background {
            /// Color Gradient BG
            Rectangle()
                .fill(Color("BG").opacity(0.6).gradient)
                .rotationEffect(.init(degrees: -180))
                .ignoresSafeArea()
        }
        .task {
            /// Adding Images
            guard images.isEmpty else { return }
            /// First Image is inital Preview Image
            previewImage = UIImage(named: "Pic 1")
            
            for index in 1...10 {
                let imageName = "Pic \(index)"
                /// Creating Thumbnail (Saves Lots of Memory)
                if let thumbnail = await UIImage(named: imageName)?.byPreparingThumbnail(ofSize: CGSize(width: 300, height: 300)) {
                    images.append(.init(imageName: imageName, thumbnail: thumbnail))
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
