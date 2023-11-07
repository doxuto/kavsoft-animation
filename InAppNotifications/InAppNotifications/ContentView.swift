//
//  ContentView.swift
//  InAppNotifications
//
//  Created by Balaji Venkatesh on 02/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet: Bool = false
    @State private var toggleDynamicIsland: Bool = true
    var body: some View {
        NavigationStack {
            VStack {
                Text("""
Button("Show") {
    UIApplication.shared.inAppNotification { _ in
        HStack { ... }
    }
}
""")
                .font(.system(size: 15))
                .lineSpacing(5)
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background(.bar, in: .rect(cornerRadius: 15))
                .padding(.horizontal, 20)
                
                Toggle("Adapt For Dynamic Island", isOn: $toggleDynamicIsland)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                
                HStack(spacing: 15) {
                    Button("Show Sheet") {
                        showSheet.toggle()
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .tint(.red)
                    .sheet(isPresented: $showSheet, content: {
                        Button("Show AirDrop Notification") {
                            UIApplication.shared.inAppNotification(adaptForDynamicIsland: toggleDynamicIsland, timeout: 4, swipeToClose: true) { isDynamicIslandEnabled in
                                HStack {
                                    Image(systemName: "wifi")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.white)
                                    
                                    VStack(alignment: .leading, spacing: 2, content: {
                                        Text("AirDrop")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                        
                                        Text("From iJustine")
                                            .textScale(.secondary)
                                            .foregroundStyle(.gray)
                                    })
                                    .padding(.top, 20)
                                    
                                    Spacer(minLength: 0)
                                }
                                .padding(15)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.black)
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 10))
                        .tint(.red)
                    })
                    
                    Button("Show Notification") {
                        UIApplication.shared.inAppNotification(adaptForDynamicIsland: toggleDynamicIsland, timeout: 4, swipeToClose: true) { isDynamicIslandEnabled in
                            HStack {
                                Image("Pic")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(.circle)
                                
                                VStack(alignment: .leading, spacing: 6, content: {
                                    Text("iJustine")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text("Hello, This is iJustine!")
                                        .textScale(.secondary)
                                        .foregroundStyle(.gray)
                                })
                                .padding(.top, 20)
                                
                                Spacer(minLength: 0)
                                
                                Button(action: {}, label: {
                                    Image(systemName: "speaker.slash.fill")
                                        .font(.title2)
                                })
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.circle)
                                .tint(.white)
                            }
                            .padding(15)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.black)
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .tint(.blue)
                }
            }
            .navigationTitle("In App Notification's")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
