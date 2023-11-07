//
//  Home.swift
//  CustomVideoPlayer
//
//  Created by Balaji on 24/04/23.
//

import SwiftUI
import AVKit

struct Home: View {
    var size: CGSize
    var safeArea: EdgeInsets
    /// View Properties
    @State private var player: AVPlayer? = {
        if let bundle = Bundle.main.path(forResource: "Sample Video", ofType: "mp4") {
            return .init(url: URL(filePath: bundle))
        }
        
        return nil
    }()
    @State private var showPlayerControls: Bool = false
    @State private var isPlaying: Bool = false
    @State private var timeoutTask: DispatchWorkItem?
    @State private var isFinishedPlaying: Bool = false
    /// Video Seeker Properties
    @GestureState private var isDragging: Bool = false
    @State private var isSeeking: Bool = false
    @State private var progress: CGFloat = 0
    @State private var lastDraggedProgress: CGFloat = 0
    @State private var isObserverAdded: Bool = false
    /// Video Seeker Thumbnails
    /// When You're Closing the View Don't Forgot to set thumbnailFrames to Empty
    @State private var thumbnailFrames: [UIImage] = []
    @State private var draggingImage: UIImage?
    @State private var playerStatusObserver: NSKeyValueObservation?
    /// Rotation Properties
    @State private var isRotated: Bool = false
    @State private var deviceRotation: UIDeviceOrientation = UIDevice.current.orientation
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        VStack(spacing: 0) {
            /// Swapping Size When Rotated
            let videoPlayerSize: CGSize = .init(width: isRotated ? size.height : size.width, height: isRotated ? size.width : (size.height / 3.5))
            
            /// Custom Vide Player
            ZStack {
                if let player {
                    CustomVideoPlayer(player: player)
                        .overlay {
                            Rectangle()
                                .fill(.black.opacity(0.4))
                                .opacity(showPlayerControls || isDragging ? 1 : 0)
                                /// Animating Dragging State
                                .animation(.easeInOut(duration: 0.35), value: isDragging)
                                .overlay {
                                    PlayBackControls()
                                }
                        }
                        .overlay(content: {
                            HStack(spacing: 60) {
                                DoubleTapSeek {
                                    /// Seeking 15 sec Backward
                                    let seconds = player.currentTime().seconds - 15
                                    player.seek(to: .init(seconds: seconds, preferredTimescale: 600))
                                }
                                
                                DoubleTapSeek(isForward: true) {
                                    /// Seeking 15 sec Forward
                                    let seconds = player.currentTime().seconds + 15
                                    player.seek(to: .init(seconds: seconds, preferredTimescale: 600))
                                }
                            }
                        })
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showPlayerControls.toggle()
                            }
                            
                            /// Timing Out Controls, Only If the Video is Playing
                            if isPlaying {
                                timeoutControls()
                            }
                        }
                        .overlay(alignment: .bottomLeading, content: {
                            SeekerThumbnailView(videoPlayerSize)
                                .offset(y: isRotated ? -105 : -60)
                        })
                        .overlay(alignment: .bottom) {
                            VideoSeekerView(videoPlayerSize)
                                .offset(y: isRotated ? -35 : 0)
                        }
                }
            }
            .background(content: {
                Rectangle()
                    .fill(.black)
                    /// Since View is Rotated the Trailing side is Bottom
                    /// Since View is Rotated the Leading side is Top
                    .padding(deviceRotation == .landscapeRight ? .leading : .trailing, isRotated ? -safeArea.bottom : 0)
                    .padding(deviceRotation == .landscapeRight ? .trailing : .leading, isRotated ? -safeArea.top : 0)
            })
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if -value.translation.height > 100 {
                            /// Rotate Player
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isRotated = true
                            }
                        } else {
                            /// Go To Normal Position
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isRotated = false
                            }
                        }
                    })
            )
            .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            /// To Avoid Other View Expansion Set it;s Native View height
            .frame(width: size.width, height: size.height / 3.5, alignment: deviceRotation == .landscapeRight ? .bottomTrailing : .bottomLeading)
            .offset(y: isRotated ? -((size.height) / 3.5) : 0)
            .rotationEffect(.init(degrees: isRotated ? (deviceRotation == .landscapeRight ? -90 : 90) : 0), anchor: deviceRotation == .landscapeRight ? .topTrailing : .topLeading)
            /// Making it Top View
            .zIndex(10000)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { index in
                        GeometryReader {
                            let size = $0.size
                            
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.red.gradient)
                                .frame(width: size.width, height: size.height)
                        }
                        .frame(height: 220)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 30)
                .padding(.bottom, 15 + safeArea.bottom)
            }
        }
        .padding(.top, safeArea.top)
        .onAppear {
            guard !isObserverAdded else { return }
            /// Adding Observer to update seeker when the video is Playing
            player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 600), queue: .main, using: { time in
                /// Calculating Video Progress
                if let currentPlayerItem = player?.currentItem {
                    let totalDuration = currentPlayerItem.duration.seconds
                    guard let currentDuration = player?.currentTime().seconds else { return }
                    
                    let calculatedProgress = currentDuration / totalDuration
                    
                    if !isSeeking {
                        progress = calculatedProgress
                        lastDraggedProgress = progress
                    }
                    
                    if calculatedProgress == 1 {
                        /// Video Finished Playing
                        isFinishedPlaying = true
                        isPlaying = false
                    }
                }
            })
            
            isObserverAdded = true
            
            /// Before Generating Thumbnails, Check if the Video is Loaded
            playerStatusObserver = player?.observe(\.status, options: .new, changeHandler: { player, _ in
                if player.status == .readyToPlay && thumbnailFrames.isEmpty {
                    generateThumbnailFrames()
                }
            })
        }
        .onDisappear {
            /// Clearing Observers
            playerStatusObserver?.invalidate()
            /// When You're Closing the View Don't Forgot to set thumbnailFrames to Empty
            thumbnailFrames = []
        }
        .onChange(of: scenePhase, perform: { newValue in
            if newValue == .background && isPlaying {
                isPlaying = false
            }
        })
        .onChange(of: progress) { newValue in
            if newValue != 1 {
                isFinishedPlaying = false
            }
        }
        .onRotate { rotation in
            if rotation.isValidInterfaceOrientation {
                deviceRotation = rotation
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    isRotated = (deviceRotation == .landscapeLeft || deviceRotation == .landscapeRight)
                }
            }
        }
    }
    
    /// Dragging Thumbnail View
    @ViewBuilder
    func SeekerThumbnailView(_ videoSize: CGSize) -> some View {
        let thumbSize: CGSize = .init(width: 175, height: 100)
        ZStack {
            if let draggingImage{
                Image(uiImage: draggingImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbSize.width, height: thumbSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(alignment: .bottom, content: {
                        if let currentItem = player?.currentItem {
                            Text(CMTime(seconds: progress * currentItem.duration.seconds, preferredTimescale: 600).toTimeString())
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .offset(y: 25)
                        }
                    })
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
            } else {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
            }
        }
        .frame(width: thumbSize.width, height: thumbSize.height)
        .opacity(isDragging ? 1 : 0)
        /// Moving Along side with Gesture
        /// Adding Some Padding at Start and End
        .offset(x: progress * (videoSize.width - thumbSize.width - 20))
        .offset(x: 10)
    }
    
    /// Video Seeker View
    @ViewBuilder
    func VideoSeekerView(_ videoSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
            
            Rectangle()
                .fill(.red)
                .frame(width: max(videoSize.width * progress, 0))
        }
        .frame(height: 3)
        .overlay(alignment: .leading) {
            Circle()
                .fill(.red)
                .frame(width: 15, height: 15)
                /// Showing Drag Knob Only When Dragging
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: .init(x: progress, y: 0.5))
                /// For More Dragging Space
                .frame(width: 50, height: 50)
                .contentShape(Rectangle())
                /// Moving Along Side With Gesture Progress
                .offset(x: videoSize.width * progress)
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            /// Cancelling Existing Timeout Task
                            if let timeoutTask {
                                timeoutTask.cancel()
                            }
                            
                            /// Calculating Progress
                            let translationX: CGFloat = value.translation.width
                            let calculatedProgress = (translationX / videoSize.width) + lastDraggedProgress
                            
                            progress = max(min(calculatedProgress, 1), 0)
                            isSeeking = true
                            
                            let dragIndex = Int(progress / 0.01)
                            /// Checking if FrameThubmnails Contains the Frame
                            if thumbnailFrames.indices.contains(dragIndex) {
                                draggingImage = thumbnailFrames[dragIndex]
                            }
                        })
                        .onEnded({ value in
                            /// Storing Last Known Progress
                            lastDraggedProgress = progress
                            /// Seeking Video To Dragged Time
                            if let currentPlayerItem = player?.currentItem {
                                let totalDuration = currentPlayerItem.duration.seconds
                                
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 600))
                                
                                /// Re-Scheduling Timeout Task
                                if isPlaying {
                                    timeoutControls()
                                }
                                
                                /// Releasing With Slight Delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isSeeking = false
                                }
                            }
                        })
                )
                .offset(x: progress * videoSize.width > 15 ? (progress * -15) : 0)
                .frame(width: 15, height: 15)
        }
    }
    
    /// Playback Controls View
    @ViewBuilder
    func PlayBackControls() -> some View {
        HStack(spacing: 25) {
            Button {
                
            } label: {
                Image(systemName: "backward.end.fill")
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            /// Disabling Button
            /// Since we have no action's for it
            .disabled(true)
            .opacity(0.6)

            
            Button {
                if isFinishedPlaying {
                    /// Setting Video to Start and Playing Again
                    isFinishedPlaying = false
                    player?.seek(to: .zero)
                    progress = .zero
                    lastDraggedProgress = .zero
                }
                
                /// Changing Video Status to Play/Pause based on user input
                if isPlaying {
                    /// Pause Video
                    player?.pause()
                    /// Cancelling Timeout Task when the Video is Paused
                    if let timeoutTask {
                        timeoutTask.cancel()
                    }
                } else {
                    /// Play Video
                    player?.play()
                    timeoutControls()
                }
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPlaying.toggle()
                }
            } label: {
                /// Changing Icon based on Video Status
                /// Changing Icon When Video was Finished Playing
                Image(systemName: isFinishedPlaying ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            .scaleEffect(1.1)
            
            Button {
                
            } label: {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.35))
                    }
            }
            .disabled(true)
            .opacity(0.6)
        }
        /// Hiding Controls When Dragging
        .opacity(showPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: showPlayerControls && !isDragging)
    }
    
    /// Timing Out Play back controls
    /// After some 2-5 Seconds
    func timeoutControls() {
        /// Cancelling Already Pending Timeout Task
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = .init(block: {
            withAnimation(.easeInOut(duration: 0.35)) {
                showPlayerControls = false
            }
        })
        
        /// Scheduling Task
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask)
        }
    }
    
    /// Generating Thumbnail Frames
    func generateThumbnailFrames() {
        Task.detached {
            guard let asset = player?.currentItem?.asset else { return }
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            /// Min Size
            generator.maximumSize = .init(width: 250, height: 250)
            
            do {
                let totalDuration = try await asset.load(.duration).seconds
                var frameTimes: [CMTime] = []
                /// Frame Timings
                /// 1/0.1 = 100 (Frames)
                for progress in stride(from: 0, to: 1, by: 0.01) {
                    let time = CMTime(seconds: progress * totalDuration, preferredTimescale: 600)
                    frameTimes.append(time)
                }
                
                /// Generating Frame Images
                for await result in generator.images(for: frameTimes) {
                    let cgImage = try result.image
                    /// Adding Frame Image
                    await MainActor.run(body: {
                        thumbnailFrames.append(UIImage(cgImage: cgImage))
                    })
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
