//
//  ContentView.swift
//  CustomUniversalAlert
//
//  Created by Balaji Venkatesh on 17/09/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var alert: AlertConfig = .init()
    @State private var alert1: AlertConfig = .init(slideEdge: .top)
    @State private var alert2: AlertConfig = .init(slideEdge: .leading)
    @State private var alert3: AlertConfig = .init(disableOutsideTap: false, slideEdge: .trailing)
    @State private var showSheet: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Button("Show Alert's") {
                    alert.present()
                    alert1.present()
                    alert2.present()
                    alert3.present()
                }
            }
            .navigationTitle("Universal Alert")
            .toolbar(content: {
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    Image(systemName: "book.pages.fill")
                })
            })
        }
        .sheet(isPresented: $showSheet, content: {
            NavigationStack {
                VStack {
                    Button("Show Alert's") {
                        alert.present()
                        alert1.present()
                        alert2.present()
                        alert3.present()
                    }
                }
                .navigationTitle("Sheet")
            }
        })
        .alert(alertConfig: $alert) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.red.gradient)
                .frame(width: 150, height: 150)
                .overlay(content: {
                    Text("Alert From Bottom Edge")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(15)
                        .multilineTextAlignment(.center)
                })
                .onTapGesture {
                    alert.dismiss()
                }
        }
        .alert(alertConfig: $alert1) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue.gradient)
                .frame(width: 150, height: 150)
                .overlay(content: {
                    Text("Alert From Top Edge")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(15)
                        .multilineTextAlignment(.center)
                })
                .onTapGesture {
                    alert1.dismiss()
                }
        }
        .alert(alertConfig: $alert2) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.black.gradient)
                .frame(width: 150, height: 150)
                .overlay(content: {
                    Text("Alert From Leading Edge")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(15)
                        .multilineTextAlignment(.center)
                })
                .onTapGesture {
                    alert2.dismiss()
                }
        }
        .alert(alertConfig: $alert3) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.purple.gradient)
                .frame(width: 150, height: 150)
                .overlay(content: {
                    Text("Alert From Trailing Edge")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(15)
                        .multilineTextAlignment(.center)
                })
                .onTapGesture {
                    alert3.dismiss()
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(SceneDelegate())
}
