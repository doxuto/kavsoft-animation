//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 29/12/21.
//

import SwiftUI

struct ContentView: View {
    
    // Recording Status
    @State var isRecording: Bool = false
    @State var url: URL?
    @State var shareVideo: Bool = false
    
    var body: some View {
        Home()
            .overlay(alignment: .bottomTrailing) {
                // MARK: Recording Button
                Button {
                    if isRecording{
                        // Stopping
                        // Since it's Async Task
                        Task{
                            stopRecordingWithEdit()
                            isRecording = false
//                            do{
//                                self.url = try await stopRecording()
//                                isRecording = false
//                                shareVideo.toggle()
//                            }
//                            catch{
//                                print(error.localizedDescription)
//                            }
                        }
                    }
                    else{
                        
                        // Starting Recording
                        startRecording { error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            
                            // Success
                            isRecording = true
                        }
                    }
                } label: {
                 
                    Image(systemName: isRecording ? "record.circle.fill" : "record.circle")
                        .font(.largeTitle)
                        .foregroundColor(isRecording ? .red : .white)
                }
                .padding()
            }
        // Simply call share sheet modifier
            .shareSheet(show: $shareVideo, items: [url])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
