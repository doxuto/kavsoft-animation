//
//  Home.swift
//  DynamicProgressView
//
//  Created by Balaji on 04/10/22.
//

import SwiftUI

struct Home: View {
    @StateObject var progressBar: DynamicProgress = .init()
    @State var sampleProgress: CGFloat = 0
    var body: some View {
        Button("\(progressBar.isAdded ? "Stop" : "Start") Download"){
            if progressBar.isAdded{
                progressBar.removeProgressWithAnimations()
            }else{
                // MARK: Simply Call the Method with your Config
                let config = ProgressConfig(title: "iJustine Image", progressImage: "arrow.up", expandedImage: "clock.badge.checkmark.fill", tint: .yellow,rotationEnabled: true)
                progressBar.addProgressView(config: config)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .padding(.top,60)
        // MARK: Sample Progress Using Timer
        // Replace this Method with your Progress Values, It's Just Demo For Video
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()) { _ in
            if progressBar.isAdded{
                // Converting to 100 then dividing by 100
                sampleProgress += 0.3
                progressBar.updateProgressView(to: sampleProgress / 100)
            }else{
                sampleProgress = 0
            }
        }
        .statusBarHidden(progressBar.hideStatusBar)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
