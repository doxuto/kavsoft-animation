//
//  cameraModelView.swift
//  ReelscameraModel (iOS)
//
//  Created by Balaji on 06/04/22.
//

import SwiftUI
import AVFoundation

// See my Custom cameraModel Video
// Link in Description

// Refactoring Code
// Adding Camera And Microphone Permission

struct CameraView: View {
    @EnvironmentObject var cameraModel: CameraViewModel
    var body: some View{
        
        GeometryReader{proxy in
            let size = proxy.size
            
            CameraPreview(size: size)
                .environmentObject(cameraModel)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.25))
                
                Rectangle()
                    .fill(Color("Instagram"))
                    .frame(width: size.width * (cameraModel.recordedDuration / cameraModel.maxDuration))
            }
            .frame(height: 8)
            .frame(maxHeight: .infinity,alignment: .top)
        }
        .onAppear(perform: cameraModel.checkPermission)
        .alert(isPresented: $cameraModel.alert) {
            Alert(title: Text("Please Enable cameraModel Access Or Microphone Access!!!"))
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if cameraModel.recordedDuration <= cameraModel.maxDuration && cameraModel.isRecording{
                cameraModel.recordedDuration += 0.01
            }
            
            if cameraModel.recordedDuration >= cameraModel.maxDuration && cameraModel.isRecording{
                // Stopping the Recording
                cameraModel.stopRecording()
                cameraModel.isRecording = false
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @EnvironmentObject var cameraModel : CameraViewModel
    var size: CGSize
    
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView()
        
        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.preview.frame.size = size
        
        cameraModel.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraModel.preview)
        
        cameraModel.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

