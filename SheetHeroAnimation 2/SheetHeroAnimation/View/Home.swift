//
//  Home.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 24/08/23.
//

import SwiftUI

struct Home: View {
    @State private var selectedProfile: Profile?
    @State private var showProfileView: Bool = false
    @Environment(WindowSharedModel.self) private var windowSharedModel
    @Environment(SceneDelegate.self) private var sceneDelegate
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                ForEach(profiles) { profile in
                    HStack(spacing: 12) {
                        /// To Find View's Position
                        GeometryReader(content: { geometry in
                            let rect = geometry.frame(in: .global)
                            
                            Image(profile.profilePicture)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: rect.width, height: rect.height)
                                .clipShape(.circle)
                                .contentShape(.circle)
                                .opacity(windowSharedModel.selectedProfile?.id == profile.id ? (windowSharedModel.hideNativeView || showProfileView ? 0 : 1) : 1)
                                .onTapGesture {
                                    Task {
                                        /// Opening Profile
                                        selectedProfile = profile
                                        windowSharedModel.selectedProfile = profile
                                        /// Which will result in 25, thus matching with the sheet corner radius
                                        windowSharedModel.cornerRadius = rect.width / 2
                                        windowSharedModel.sourceRect = rect
                                        /// Storing the Source Rect for Closing Animation
                                        windowSharedModel.previousSourceRect = rect
                                        
                                        try? await Task.sleep(for: .seconds(0))
                                        windowSharedModel.hideNativeView = true
                                        showProfileView.toggle()
                                        
                                        /// After Animation Finished, Removing Hero View
                                        try? await Task.sleep(for: .seconds(0.5))
                                        if windowSharedModel.hideNativeView {
                                            windowSharedModel.hideNativeView = false
                                        }
                                    }
                                }
                        })
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4, content: {
                            Text(profile.userName)
                                .fontWeight(.bold)
                            
                            Text(profile.lastMsg)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(profile.lastActive)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(15)
            .padding(.horizontal, 5)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showProfileView, content: {
            DetailProfileView(
                showProfileView: $showProfileView,
                selectedProfile: $selectedProfile
            )
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(25)
            .interactiveDismissDisabled()
            .presentationDragIndicator(.hidden)
        })
        /// Adding Hero Overlay Window For Performing Hero Animation's
        .onAppear(perform: {
            guard sceneDelegate.heroWindow == nil else { return }
            sceneDelegate.addHeroWindow(windowSharedModel)
        })
    }
}

#Preview {
    ContentView()
}
