//
//  Home.swift
//  LinkPreviewSwiftUI (iOS)
//
//  Created by Balaji on 05/12/21.
//

import SwiftUI

struct Home: View {
    
    // State Object...
    @StateObject var messageData: MessageViewModel = MessageViewModel()
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    ForEach(messageData.messages){message in
                        
                        CardView(message: message)
                    }
                }
            }
            // Safe Area Bottom bar with Textfield...
            .safeAreaInset(edge: .bottom) {
                
                HStack(spacing: 12){
                    
                    TextField("Enter Message", text: $messageData.message)
                        .textFieldStyle(.roundedBorder)
                        .textCase(.lowercase)
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    // Send Button...
                    Button {
                        messageData.sendMessage()
                    } label: {
                        
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }

                }
                .padding()
                .padding(.top)
                // background Blur...
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Link Preview")
        }
        // We always need dark mode...
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func CardView(message: Message)->some View{
        
        Group{
            
            // if there is a link preview then showing it...
            // else showing loading...
            // otherwise showing general message...
            if message.previewLoading{
                
                Group{
                    
                    if let metaData = message.linkMetaData{
                        
                        // Link Preview...
                        LinkPreview(metaData: metaData)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: getRect().width - 80,alignment: .leading)
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity,alignment: .trailing)
                    }
                    else{
                        // ProgressView...
                        HStack(spacing: 10){
                            
                            // Showing URL Host only...
                            Text(message.linkURL?.host ?? "")
                                .font(.caption)
                            
                            ProgressView()
                                .tint(.white)
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.35))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity,alignment: .trailing)
                    }
                }
            }
            else{
                // Normal Message...
                
                Text(message.messageString)
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                // maxWidth....
                    .frame(width: getRect().width - 80,alignment: .trailing)
                    .frame(maxWidth: .infinity,alignment: .trailing)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
