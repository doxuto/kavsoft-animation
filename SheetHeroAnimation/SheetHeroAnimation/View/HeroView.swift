//
//  HeroView.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 24/08/23.
//

import SwiftUI

struct CustomHeroAnimationView: View {
    @EnvironmentObject private var windowSharedModel: WindowSharedModel
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        GeometryReader(content: { geometry in
            //let safeArea = geometry.safeAreaInsets
            VStack {
                let sourceRect = windowSharedModel.sourceRect
                if let selectedProfile = windowSharedModel.selectedProfile, windowSharedModel.hideNativeView {
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: sourceRect.width, height: sourceRect.height)
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
                            .opacity(windowSharedModel.showGradient ? 1 : 0)
                        }
                        .clipShape(.rect(cornerRadius: windowSharedModel.cornerRadius))
                        .offset(x: sourceRect.minX, y: sourceRect.minY)
                        .animation(.snappy(duration: 0.3, extraBounce: 0), value: windowSharedModel.showGradient)
                        .transition(.identity)
                }
            }
            /// Animating Frame Changes
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: windowSharedModel.sourceRect)
            .ignoresSafeArea()
        })
    }
}
