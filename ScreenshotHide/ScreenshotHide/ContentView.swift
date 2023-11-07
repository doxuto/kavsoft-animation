//
//  ContentView.swift
//  ScreenshotHide
//
//  Created by Balaji on 14/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ScreenshotPreventView {
                        GeometryReader {
                            let size = $0.size
                            
                            Image(.pic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(topLeadingRadius: 100, bottomTrailingRadius: 100))
                        }
                        .padding(15)
                    }
                    .navigationTitle("iJustine")
                } label: {
                    Text("Show Image")
                }

                NavigationLink {
                    List {
                        Section("API Key") {
                            ScreenshotPreventView {
                                Text("ITU98DHGMmgk812KUGNW")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        Section("APNS Key") {
                            ScreenshotPreventView {
                                Text("enitsuji")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .navigationTitle("Key's")
                } label: {
                    Text("Show Security Keys")
                }
            }
            .navigationTitle("My List")
        }
    }
}

#Preview {
    ContentView()
}
