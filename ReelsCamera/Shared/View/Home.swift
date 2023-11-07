//
//  Home.swift
//  ReelsCamera (iOS)
//
//  Created by Balaji on 06/04/22.
//

import SwiftUI
import AVKit

struct Home: View {
    @StateObject var cameraModel = CameraViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Camera View
            CameraView()
                .environmentObject(cameraModel)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding(.top,10)
                .padding(.bottom,30)
            
            // MARK: Controls
            ZStack{
                
                Button {
                    if cameraModel.isRecording{
                        cameraModel.stopRecording()
                    }
                    else{
                        cameraModel.startRecording()
                    }
                } label: {
                    Image("Reels")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .opacity(cameraModel.isRecording ? 0 : 1)
                        .padding(12)
                        .frame(width: 60, height: 60)
                        .background{
                            Circle()
                                .stroke(cameraModel.isRecording ? .clear : .black)
                        }
                        .padding(6)
                        .background{
                            Circle()
                                .fill(cameraModel.isRecording ? .red : .white)
                        }
                }
                
                // Preview Button
                Button {
                    if let _ = cameraModel.previewURL{
                        cameraModel.showPreview.toggle()
                    }
                } label: {
                    Group{
                        if cameraModel.previewURL == nil && !cameraModel.recordedURLs.isEmpty{
                            // Merging Videos
                            ProgressView()
                                .tint(.black)
                        }
                        else{
                            Label {
                                Image(systemName: "chevron.right")
                                    .font(.callout)
                            } icon: {
                                Text("Preview")
                            }
                            .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal,20)
                    .padding(.vertical,8)
                    .background{
                        Capsule()
                            .fill(.white)
                    }
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.trailing)
                .opacity((cameraModel.previewURL == nil && cameraModel.recordedURLs.isEmpty) || cameraModel.isRecording ? 0 : 1)
            }
            .frame(maxHeight: .infinity,alignment: .bottom)
            .padding(.bottom,10)
            .padding(.bottom,30)
            
            Button {
                cameraModel.recordedDuration = 0
                cameraModel.previewURL = nil
                cameraModel.recordedURLs.removeAll()
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
            .padding()
            .padding(.top)
            .opacity(!cameraModel.recordedURLs.isEmpty && cameraModel.previewURL != nil && !cameraModel.isRecording ? 1 : 0)
        }
        .overlay(content: {
            if let url = cameraModel.previewURL,cameraModel.showPreview{
                FinalPreview(url: url, showPreview: $cameraModel.showPreview)
                    .transition(.move(edge: .trailing))
            }
        })
        .animation(.easeInOut, value: cameraModel.showPreview)
        .preferredColorScheme(.dark)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Final Video Preview
struct FinalPreview: View{
    var url: URL
    @Binding var showPreview: Bool
    
    var body: some View{
        GeometryReader{proxy in
            let size = proxy.size
            
            VideoPlayer(player: AVPlayer(url: url))
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            // MARK: Back Button
                .overlay(alignment: .topLeading) {
                    Button {
                        showPreview.toggle()
                    } label: {
                        Label {
                            Text("Back")
                        } icon: {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.leading)
                    .padding(.top,22)
                }
        }
    }
}
