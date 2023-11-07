//
//  ContentView.swift
//  iOS16LockScreen
//
//  Created by Balaji on 10/08/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var lockscreenModel: LockscreenModel = .init()
    var body: some View {
        CustomColorFinderView(content: {
            Home()
        }, onLoad: {view in
            lockscreenModel.view = view
        })
        .overlay(alignment: .top, content: {
            TimeView()
                .environmentObject(lockscreenModel)
                .opacity(lockscreenModel.placeTextAbove ? 1 : 0)
        })
        // Since Home is EdgesIgnored
        // We Need to Ignore it for UIKit Translated View
        .ignoresSafeArea()
        .environmentObject(lockscreenModel)
        // MARK: Adding Scaling
        .gesture(
            MagnificationGesture(minimumScaleDelta: 0.01)
                .onChanged({ value in
                    lockscreenModel.scale = value + lockscreenModel.lastScale
                    lockscreenModel.verifyScreenColor()
                }).onEnded({ _ in
                    if lockscreenModel.scale < 1{
                        withAnimation(.easeInOut(duration: 0.15)){
                            lockscreenModel.scale = 1
                        }
                    }
                    // MARK: Excluding the Main Scale 1
                    lockscreenModel.lastScale = lockscreenModel.scale - 1
                    // MARK: After Animation Completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        lockscreenModel.verifyScreenColor()
                    }
                })
        )
        .environmentObject(lockscreenModel)
        .onChange(of: lockscreenModel.onLoad) { newValue in
            // What if The Image is Already Above Initially
            if newValue{lockscreenModel.verifyScreenColor()}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
