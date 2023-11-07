//
//  DetailView.swift
//  SnapTransition
//
//  Created by Balaji on 19/01/23.
//

import SwiftUI
import AVKit

struct DetailView: View{
    @Binding var videoFile: VideoFile
    @Binding var isExpanded: Bool
    var animationID: Namespace.ID
    /// - View Properties
    @GestureState private var isDragging: Bool = false
    
    var body: some View{
        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            CardView(videoFile: $videoFile, isExpanded: $isExpanded, animationID: animationID,isDetailView: true) {
                OverlayView()
                    .frame(width: size.width, height: size.height)
                    .padding(.top,safeArea.top)
                    .padding(.bottom,safeArea.bottom)
            }
            .ignoresSafeArea()
        }
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    var translation = value.translation
                    translation = isDragging && isExpanded ? translation : .zero
                    videoFile.offset = translation
                }).onEnded({ value in
                    /// - Your Condition
                    if value.translation.height > 200{
                        /// - Closing View With Animation
                        videoFile.player.pause()
                        
                        /// - First Closing View And In the Mid of Animation Resetting The player to Start and Hiding the Video View
                        
                        /// - You may fix the interactiveSpring() Animation Bug if you are experiencing any delays or glitches by changing the spring animation to easeInOut.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                            videoFile.player.seek(to: .zero)
                            videoFile.playVideo = false
                        }

                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)){
                            videoFile.offset = .zero
                            isExpanded = false
                        }
                        
                        /// - EaseInOut Implementation
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                            videoFile.player.seek(to: .zero)
//                            videoFile.playVideo = false
//                        }
//
//                        withAnimation(.easeInOut(duration: 0.25)){
//                            videoFile.offset = .zero
//                            isExpanded = false
//                        }
                    }else{
                        withAnimation(.easeInOut(duration: 0.25)){
                            videoFile.offset = .zero
                        }
                    }
                })
        )
        .onAppear {
            /// - Playing the Video As Soon the Animation Finished
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.28){
                /// - Transition Needs Animation
                withAnimation(.easeInOut){
                    videoFile.playVideo = true
                    videoFile.player.play()
                }
            }
        }
    }
    
    /// - Sample Overlay View
    @ViewBuilder
    func OverlayView()->some View{
        VStack{
            HStack{
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("iJustine")
                        .font(.callout)
                        .fontWeight(.bold)
                    Text("4 hr ago")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                
                Image(systemName: "bookmark")
                    .font(.title3)
                
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .rotationEffect(.init(degrees: -90))
            }
            .foregroundColor(.white)
            .frame(maxHeight: .infinity,alignment: .top)
            /// - Hiding When Dragging
            .opacity(isDragging ? 0 : 1)
            .animation(.easeInOut(duration: 0.2), value: isDragging)
            
            Button {
                
            } label: {
                Text("View More Episodes")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.horizontal,12)
                    .padding(.vertical,8)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                Button {
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                }
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical,10)
        /// - Displaying Only When Videos Starts Playing
        .opacity(videoFile.playVideo && isExpanded ? 1 : 0)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
