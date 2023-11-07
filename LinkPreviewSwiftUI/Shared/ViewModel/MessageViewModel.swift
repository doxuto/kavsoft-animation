//
//  MessageViewModel.swift
//  LinkPreviewSwiftUI (iOS)
//
//  Created by Balaji on 05/12/21.
//

import SwiftUI
import LinkPresentation

class MessageViewModel: ObservableObject {
    @Published var message: String = ""
    
    // All Messages...
    @Published var messages: [Message] = []
    
    func sendMessage(){
        
        // adding to messages....
        if !isMessageURL(){
            addToMessage()
            return
        }
        
        // Extracting URl Meta Data....
        // before that adding loading Indicator....
        guard let url = URL(string: message) else{
            return
        }
        
        let urlMessage = Message(messageString: message,previewLoading: true,linkURL: url)
        messages.append(urlMessage)
        
        // Extracting Data...
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) {[self] meta, err in
            
            // if failure adding as an normal message...
            
            DispatchQueue.main.async {
                
                self.message = ""
                
                if let _ = err {
                    addToMessage()
                    return
                }
                
                guard let meta = meta else {
                    addToMessage()
                    return
                }
                
                // if success then finding the loading view index and adding the meta data....
                if let index = messages.firstIndex(where: { message in
                    return urlMessage.id == message.id
                }){
                    messages[index].linkMetaData = meta
                }
            }
        }
    }
    
    // checking if message is URL...
    func isMessageURL()->Bool{
        
        if let url = URL(string: message){
            
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
    
    func addToMessage(){
        messages.append(Message(messageString: message))
        message = ""
    }
}
