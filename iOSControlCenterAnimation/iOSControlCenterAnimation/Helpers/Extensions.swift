//
//  Extensions.swift
//  iOSControlCenterAnimation
//
//  Created by Balaji on 01/01/23.
//

import SwiftUI

extension View{
    /// - Reverse Mask Modifier
    @ViewBuilder
    func reverseMask<Content: View>(@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .mask {
                Rectangle()
                    .overlay {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
    
    /// - Custom Background Modifier
    @ViewBuilder
    func addRoundedBG()->some View{
        self
            .background {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.thinMaterial)
            }
    }
    
    /// - Hiding Content
    @ViewBuilder
    func hideView(_ configs: [Config])->some View{
        let status = configs.contains{$0.expand}
        self
            .opacity(status ? 0 : 1)
            .animation(.easeInOut(duration: 0.2), value: status)
    }
    
    /// - Haptics
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle){
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
