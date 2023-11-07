//
//  VideoCoverScroller.swift
//  ThumbnailVideoScroller (iOS)
//
//  Created by Balaji on 20/02/22.
//

import SwiftUI
import AVKit
import AVFoundation

// MARK: Custom Cover Scroller
struct VideoCoverScroller: View{
    // Making it Dynamic
    @Binding var videoURL: URL
    @Binding var progress: CGFloat
    
    @State var imageSequence: [UIImage]?
    
    // MARK: Gesture Properties
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    // MARK: Cover Image
    var imageSize: CGSize
    @Binding var coverImage: UIImage?
    
    var body: some View{
        
        GeometryReader{proxy in
            let size = proxy.size
            
            HStack(spacing: 0){
                
                // Image Sequence
                if let imageSequence = imageSequence {
                    
                    ForEach(imageSequence,id: \.self){index in
                        GeometryReader{proxy in
                            let subSize = proxy.size
                            
                            Image(uiImage: index)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: subSize.width, height: subSize.height)
                                .clipped()
                        }
                        .frame(height: size.height)
                    }
                }
            }
            .cornerRadius(6)
            .overlay(alignment: .leading, content: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.black)
                        .opacity(0.25)
                        .frame(height: size.height)
                    
                    PreviewPlayer(url: $videoURL, progress: $progress)
                        .frame(width: 35, height: 60)
                        .cornerRadius(6)
                        .background(
                        
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(.white,lineWidth: 3)
                                .padding(-3)
                        )
                        .background(
                        
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(.black.opacity(0.2))
                                .padding(-4)
                        )
                        .offset(x: offset)
                        .gesture(
                        
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    // Removing Dragger Radius
                                    // 35/2 = 17.5
                                    var translation = (isDragging ? value.location.x - 17.5 : 0)
                                    translation = (translation < 0 ? 0 : translation)
                                    translation = (translation > size.width - 35 ? size.width - 35 : translation)
                                    offset = translation
                                    
                                    // Updating Progress
                                    self.progress = (translation / (size.width - 35))
                                })
                                .onEnded({ _ in
                                    retrieveCoverImageAt(progress: progress, size: imageSize) { image in
                                        self.coverImage = image
                                    }
                                })
                        )
                }
            })
            .onAppear {
                if imageSequence == nil{
                    generateImageSequence()
                }
            }
            .onChange(of: videoURL) { _ in
                // Clearing Data and Regenrating for New URL
                progress = 0
                offset = .zero
                coverImage = nil
                imageSequence = nil
                
                generateImageSequence()
                retrieveCoverImageAt(progress: progress, size: imageSize) { image in
                    self.coverImage = image
                }
            }
        }
        .frame(height: 50)
    }
    
    func generateImageSequence(){
        // Spiliting Duration into 10 Secs of each
        let parts = (videoDuration() / 10)
        
        (0..<10).forEach { index in
            
            // Retrieving Cover Image
            // Converting Index to progress with respect to duration
            let progress = (CGFloat(index) * parts) / videoDuration()
            
            // Since we dont need that much big image
            retrieveCoverImageAt(progress: progress, size: CGSize(width: 100, height: 100)) { image in
                // Checking if sequence is nil
                if imageSequence == nil{imageSequence = Array(repeating: .init(), count: 10)}
                imageSequence?[index] = image
            }
        }
    }
    
    func retrieveCoverImageAt(progress: CGFloat,size: CGSize,completion: @escaping (UIImage)->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            let asset = AVAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = size
            
            // Again converting progress into seconds
            let time = CMTime(seconds: progress * videoDuration(), preferredTimescale: 600)
            
            do{
                let image = try generator.copyCGImage(at: time, actualTime: nil)
                let cover = UIImage(cgImage: image)
                
                DispatchQueue.main.async {
                    completion(cover)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    // Retrieving Duration
    func videoDuration()->Double{
        let asset = AVAsset(url: videoURL)
        
        return asset.duration.seconds
    }
}

struct VideoCoverScroller_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
