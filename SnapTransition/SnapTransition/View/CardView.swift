//
//  CardView.swift
//  SnapTransition
//
//  Created by Balaji on 18/01/23.
//

import SwiftUI
import AVKit

/// - Custom View Builder
/// - Which Allows to place custom overlay on Card views
struct CardView<Overlay: View>: View {
    var overlay: Overlay
    /// - View Properties
    @Binding var videoFile: VideoFile
    @Binding var isExpanded: Bool
    var animationID: Namespace.ID
    var isDetailView: Bool = false
    
    init(videoFile: Binding<VideoFile>,isExpanded: Binding<Bool>,animationID: Namespace.ID,isDetailView: Bool = false,@ViewBuilder overlay: @escaping ()->Overlay){
        self._videoFile = videoFile
        self._isExpanded = isExpanded
        self.isDetailView = isDetailView
        self.animationID = animationID
        self.overlay = overlay()
    }
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            /// - Displaying Thumbail Instead of showing paused video
            /// - For Saving Memory
            /// - Displaying Thumbnail
            if let thumbnail = videoFile.thumbnail{
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(videoFile.playVideo ? 0 : 1)
                    .frame(width: size.width, height: size.height)
                    .overlay(content: {
                        /// - Displaying Video Player Only For Detail View
                        if videoFile.playVideo && isDetailView{
                            CustomVideoPlayer(player: videoFile.player)
                                .transition(.identity)
                        }
                    })
                    .overlay(content: {
                        /// - Displaying OVerlay View
                        overlay
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .scaleEffect(scale)
            }else{
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear {
                        /// - Since We need the Intial Image
                        extractImageAt(time: .zero, size: screenSize) { thumbnail in
                            videoFile.thumbnail = thumbnail
                        }
                    }
            }
        }
        /// - Adding Mathed Geometry
        .matchedGeometryEffect(id: videoFile.id.uuidString, in: animationID)
        /// - Adding Offset & Scaling
        .offset(videoFile.offset)
        /// - Making it Center
        .offset(y: videoFile.offset.height * -0.7)
    }
    
    /// - Dynamic Scaling Based On Offset
    var scale: CGFloat{
        var yOffset = videoFile.offset.height
        /// - Applying Scaling Only When Dragged Downwards
        yOffset = yOffset < 0 ? 0 : yOffset
        var progress = yOffset / screenSize.height
        /// - Limiting Progress
        progress = 1 - (progress > 0.4 ? 0.4 : progress)
        /// - When the View is Closed Immediately Resetting Scale to 1
        return (isExpanded ? progress : 1)
    }
    
    /// - Extracting Thumbnail From Video using AVAssetGenerator
    func extractImageAt(time: CMTime,size: CGSize,completion: @escaping (UIImage)->()){
        DispatchQueue.global(qos: .userInteractive).async {
            let asset = AVAsset(url: videoFile.fileURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = size
            
            Task{
                do{
                    let cgImage = try await generator.image(at: time).image
                    guard let colorCorrectedImage = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else{return}
                    let thumbnail = UIImage(cgImage: colorCorrectedImage)
                    /// UI Must be Updated on Main Thread
                    await MainActor.run(body: {
                        completion(thumbnail)
                    })
                }catch{
                    print("Failed to Fetch Thumbnail")
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    /// - Current Phone Screen Size
    var screenSize: CGSize{
        guard let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen.bounds.size else{return .zero}
        return size
    }
}
