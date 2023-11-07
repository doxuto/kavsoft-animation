//
//  Extensions.swift
//  AdvancedAnimation (iOS)
//
//  Created by Balaji on 01/02/22.
//

import SwiftUI
import ReplayKit

// MARK: App Recording Extensions
extension View{
    
    // MARK: Start Recording
    func startRecording(enableMicorphone: Bool = false,completion: @escaping (Error?)->()){
        
        let recorder = RPScreenRecorder.shared()
        
        // Micorphone Option
        recorder.isMicrophoneEnabled = false
        
        // Starting Recording
        recorder.startRecording(handler: completion)
    }
    
    // MARK: Stop Recording
    // Allows Editing
    func stopRecordingWithEdit(){
        
        let recorder = RPScreenRecorder.shared()
        let delegate = ReplayDelegate()
        
        recorder.stopRecording { controller, err in
            if let controller = controller{
                controller.modalPresentationStyle = .fullScreen
                controller.previewControllerDelegate = delegate
                DispatchQueue.main.async {
                    rootController().present(controller, animated: true)
                }
            }
        }
    }
    
    // MARK: Stop Recording
    // It will return the Recorded Video URL
    func stopRecording()async throws->URL{
        
        let recorder = RPScreenRecorder.shared()
        
        // File will be stored in Temporary Directory
        // Video Name
        let name = UUID().uuidString + ".mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        
        try await recorder.stopRecording(withOutput: url)
        
        return url
    }
    
    // MARK: Cancel Recording
    // Optinal
    func cancelRecording(){
        let recorder = RPScreenRecorder.shared()
        recorder.discardRecording {}
    }
    
    // MARK: Share Sheet
    // It's a Custom Modifier
    func shareSheet(show: Binding<Bool>,items: [Any?])->some View{
        return self
            .sheet(isPresented: show) {
                
            } content: {
                // Wrapping the Optinals
                let items = items.compactMap { item -> Any? in
                    return item
                }
                
                if !items.isEmpty{
                    ShareSheet(items: items)
                }
            }
    }
    
    func rootController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}

class ReplayDelegate: NSObject, RPPreviewViewControllerDelegate{
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
}
