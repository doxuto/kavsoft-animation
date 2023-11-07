//
//  DetailProfileView.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 25/08/23.
//

import SwiftUI

/// Detail Profile View
struct DetailProfileView: View {
    @Binding var showProfileView: Bool
    @Binding var selectedProfile: Profile?
    /// Color Sceheme
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var windowSharedModel: WindowSharedModel
    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                let size = geometry.size
                let rect = geometry.frame(in: .global)
                
                if let selectedProfile {
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .overlay {
                            let color = scheme == .dark ? Color.black : Color.white
                            LinearGradient(colors: [
                                .clear,
                                .clear,
                                .clear,
                                color.opacity(0.1),
                                color.opacity(0.5),
                                color.opacity(0.9),
                                color,
                            ], startPoint: .top, endPoint: .bottom)
                        }
                        .clipped()
                        .opacity(windowSharedModel.hideNativeView ? 0 : 1)
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: { value in
                            if showProfileView {
                                windowSharedModel.sourceRect = value
                                /// Showing Gradient
                                windowSharedModel.showGradient = true
                            }
                        })
                }
            })
            .frame(maxHeight: 330)
            .overlay(alignment: .topLeading) {
                Button(action: {
                    /// Closing the Same Way as Opening
                    Task {
                        windowSharedModel.hideNativeView = true
                        showProfileView = false
                        try? await Task.sleep(for: .seconds(0))
                        /// Using the Stored Source Frame Rect to Re Position to it's original place
                        windowSharedModel.sourceRect = windowSharedModel.previousSourceRect
                        windowSharedModel.showGradient = false
                        /// Waiting for animation Completion
                        try? await Task.sleep(for: .seconds(0.5))
                        if windowSharedModel.hideNativeView {
                            windowSharedModel.reset()
                            selectedProfile = nil
                        }
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .contentShape(.rect)
                        .padding(10)
                        .background(.black, in: .circle)
                })
                .padding([.leading, .top], 20)
                .scaleEffect(0.9)
                .opacity(windowSharedModel.hideNativeView ? 0 : 1)
                .animation(.snappy, value: windowSharedModel.hideNativeView)
            }
            
            Spacer()
        }
    }
}
