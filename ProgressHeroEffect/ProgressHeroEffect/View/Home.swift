//
//  Home.swift
//  ProgressHeroEffect
//
//  Created by Balaji Venkatesh on 13/10/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var allProfiles: [Profile] = profiles
    /// Detail Properties
    @State private var selectedProfile: Profile?
    @State private var showDetail: Bool = false
    @State private var heroProgress: CGFloat = 0
    @State private var showHeroView: Bool = true
    var body: some View {
        NavigationStack {
            List(allProfiles) { profile in
                HStack(spacing: 12) {
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                        .opacity(selectedProfile?.id == profile.id ? 0 : 1)
                        /// Source Anchor Frame
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return [profile.id.uuidString: anchor]
                        })
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text(profile.userName)
                            .fontWeight(.semibold)
                        
                        Text(profile.lastMsg)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    })
                }
                .contentShape(.rect)
                .onTapGesture {
                    selectedProfile = profile
                    showDetail = true
                    
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                        heroProgress = 1.0
                    } completion: {
                        Task {
                            try? await Task.sleep(for: .seconds(0.11))
                            showHeroView = false
                        }
                    }
                }
            }
            .navigationTitle("Progress Effect")
            .allowsHitTesting(!showDetail)
        }
        .overlay {
            if showDetail {
                DetailView(
                    selectedProfile: $selectedProfile,
                    heroProgress: $heroProgress,
                    showDetail: $showDetail,
                    showHeroView: $showHeroView
                )
                .allowsHitTesting(!showHeroView)
                .transition(.identity)
            }
        }
        /// Hero Animation Layer
        .overlayPreferenceValue(AnchorKey.self, { value in
            GeometryReader { geometry in
                /// Let's Check Whether We Have Both Source and Destination Frames
                if let selectedProfile,
                    let source = value[selectedProfile.id.uuidString],
                   let destination = value["DESTINATION"] {
                    let sourceRect = geometry[source]
                    let radius = sourceRect.height / 2
                    let destnationRect = geometry[destination]
                    
                    let diffSize = CGSize(
                        width: destnationRect.width - sourceRect.width,
                        height: destnationRect.height - sourceRect.height
                    )
                    
                    let diffOrigin = CGPoint(
                        x: destnationRect.minX - sourceRect.minX,
                        y: destnationRect.minY - sourceRect.minY
                    )
                    
                    /// YOUR HERO VIEW
                    /// MINE IS JUST A PROFILE IMAGE
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: sourceRect.width + (diffSize.width * heroProgress),
                            height: sourceRect.height + (diffSize.height * heroProgress)
                        )
                        .clipShape(.rect(cornerRadius: radius))
                        .offset(
                            x: sourceRect.minX + (diffOrigin.x * heroProgress),
                            y: sourceRect.minY + (diffOrigin.y * heroProgress)
                        )
                        .opacity(showHeroView ? 1 : 0)
                        .animation(.none, value: showHeroView)
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
