//
//  Home.swift
//  iOSControlCenterAnimation
//
//  Created by Balaji on 01/01/23.
//

import SwiftUI

struct Home: View {
    var size: CGSize
    var safeArea: EdgeInsets
    /// - View Properties
    @State private var volumeConfig: Config = .init()
    @State private var brightnessConfig: Config = .init()
    @Namespace private var namespace
    var body: some View {
        ZStack{
            let paddedWidth = size.width - 50
            
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width)
                .blur(radius: 45, opaque: true)
                .clipped()
                .onTapGesture(perform: resetConfig)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15), count: 2),spacing: 15) {
                ActionView()
                    .frame(height: paddedWidth * 0.5)
                    .background {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.thinMaterial)
                            /// - Reverse Masking / Inverted Mask
                            .reverseMask {
                                ActionView(true)
                            }
                    }
                    .hideView([volumeConfig,brightnessConfig])
                
                AudioControl()
                    .frame(height: paddedWidth * 0.5)
                    .hideView([volumeConfig,brightnessConfig])
                
                OtherControls()
                    .frame(height: paddedWidth * 0.5)
                    .hideView([volumeConfig,brightnessConfig])
                
                InteractiveControls()
                    .frame(height: paddedWidth * 0.5)
                    .hideView([volumeConfig,brightnessConfig])
            }
            .frame(maxHeight: .infinity,alignment: .top)
            .padding(.vertical,15)
            .padding(.horizontal,25)
            .padding(.top,safeArea.top)
            .overlay(content: {
                ExpandedVolumeControl(paddedWidth)
                    .overlay(alignment: .top) {
                        ZStack{
                            if volumeConfig.animateContent{
                                Image(systemName: "speaker.wave.3.fill",variableValue: volumeConfig.progress)
                                    .font(.title)
                                    .blendMode(.overlay)
                                    .offset(y: -110)
                                    .transition(.opacity)
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: volumeConfig.animateContent)
                    }
                ExpandedBrightnessControl(paddedWidth)
                    .overlay(alignment: .top) {
                        ZStack{
                            if brightnessConfig.animateContent{
                                Image(systemName: "sun.max.fill")
                                    .font(.title)
                                    .blendMode(.overlay)
                                    .offset(y: -110)
                                    .transition(.opacity)
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: brightnessConfig.animateContent)
                    }
            })
            .animation(.easeInOut(duration: 0.2), value: volumeConfig.expand)
            .animation(.easeInOut(duration: 0.2), value: brightnessConfig.expand)
            .environment(\.colorScheme, .dark)
        }
    }
    
    /// - Volume/Brightness Control
    @ViewBuilder
    func InteractiveControls()->some View{
        HStack(spacing: 15){
            CustomSlider(
                thumbImage: "sun.max.fill",
                animationID: "EXPANDBRIGHTNESS",
                namespaceID: namespace,
                show: !brightnessConfig.expand,
                config: $brightnessConfig
            )
            .opacity(brightnessConfig.showContent ? 0 : 1)
            
            CustomSlider(
                thumbImage: "speaker.wave.3.fill",
                animationID: "EXPANDVOLUME",
                namespaceID: namespace,
                show: !volumeConfig.expand,
                config: $volumeConfig
            )
            .opacity(volumeConfig.showContent ? 0 : 1)
        }
    }
    
    /// - Expanded Volume Control View
    @ViewBuilder
    func ExpandedVolumeControl(_ width: CGFloat)->some View{
        if volumeConfig.expand{
            VStack{
                CustomSlider(
                    thumbImage: "speaker.wave.3.fill",
                    animationID: "EXPANDVOLUME",
                    cornerRadius: 30,
                    namespaceID: namespace,
                    show: volumeConfig.expand,
                    config: $volumeConfig
                )
                .opacity(volumeConfig.showContent ? 1 : 0)
                .frame(width: width * 0.35, height: width)
            }
            /// Play With Transitions If you need more precise Hero Effect
            .transition(.offset(x: 1, y: 1))
            .onAppear {
                volumeConfig.showContent = true
                volumeConfig.animateContent = true
            }
        }
    }
    
    /// - Expanded Brightness Control View
    @ViewBuilder
    func ExpandedBrightnessControl(_ width: CGFloat)->some View{
        if brightnessConfig.expand{
            VStack{
                CustomSlider(
                    thumbImage: "sun.max.fill",
                    animationID: "EXPANDBRIGHTNESS",
                    cornerRadius: 30,
                    namespaceID: namespace,
                    show: brightnessConfig.expand,
                    config: $brightnessConfig
                )
                .opacity(brightnessConfig.showContent ? 1 : 0)
                .frame(width: width * 0.35, height: width)
            }
            /// Play With Transitions If you need more precise Hero Effect
            .transition(.offset(x: 1, y: 1))
            .onAppear {
                brightnessConfig.showContent = true
                brightnessConfig.animateContent = true
            }
        }
    }
    
    /// - Action View
    /// Masking Out
    @ViewBuilder
    func ActionView(_ mask: Bool = false)->some View{
        VStack(spacing: 15){
            HStack(spacing: 15){
                ButtonView(image: "airplane",mask)
                ButtonView(image: "antenna.radiowaves.left.and.right",mask)
            }
            
            HStack(spacing: 15){
                ButtonView(image: "wifi",mask)
                ButtonView(image: "personalhotspot",mask)
            }
        }
        .padding(15)
    }
    
    /// - Button View
    @ViewBuilder
    func ButtonView(image: String,_ mask: Bool = false)->some View{
        Image(systemName: image)
            .font(.title2)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background {
                if mask{
                    Circle()
                }
            }
    }
    
    /// - AudioControl
    @ViewBuilder
    func AudioControl()->some View{
        VStack{
            HStack(spacing: 0){
                Image(systemName: "backward.fill")
                    .foregroundColor(.gray)
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                Image(systemName: "forward.fill")
                    .foregroundColor(.gray)
            }
            .font(.title3)
        }
        .padding(.horizontal,15)
        .padding(.bottom,30)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
        .addRoundedBG()
    }
    
    /// - Other Controls
    @ViewBuilder
    func OtherControls()->some View{
        VStack(spacing: 15){
            HStack(spacing: 15){
                Image(systemName: "lock.open.rotation")
                    .font(.title)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .addRoundedBG()
                
                Image(systemName: "rectangle.on.rectangle")
                    .font(.title)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .addRoundedBG()
            }
            
            HStack(spacing: 10){
                Image(systemName: "person.fill")
                    .font(.title2)
                    .frame(width: 50, height: 50)
                
                Text("Focus")
                    .fontWeight(.medium)
            }
            .padding(.horizontal,10)
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
            .background {
                Color.clear
                    .addRoundedBG()
                    /// - Applying Reverse Mask
                    .reverseMask {
                        Circle()
                            .frame(width: 50, height: 50)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.leading,10)
                    }
            }
        }
    }
    
    /// - Resetting View
    func resetConfig(){
        volumeConfig.expand = false
        brightnessConfig.expand = false
        
        volumeConfig.animateContent = false
        brightnessConfig.animateContent = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            volumeConfig.showContent = false
            brightnessConfig.showContent = false
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Custom Slider With Hero Effect(Matched Geometry Effect)
struct CustomSlider: View{
    var thumbImage: String
    var animationID: String
    /// - Since When We Expand Our Slider, Corner Radius will be Differed
    var cornerRadius: CGFloat = 18
    var namespaceID: Namespace.ID
    /// - Used to Show/Hide Between MatchedGeometry Effect
    var show: Bool
    @Binding var config: Config
    
    var body: some View{
        GeometryReader{
            let size = $0.size
            
            ZStack{
                if show{
                    Rectangle()
                        .fill(.thinMaterial)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.white)
                                .scaleEffect(y: config.progress, anchor: .bottom)
                        }
                        .overlay(alignment: .bottom) {
                            Image(systemName: thumbImage,variableValue: config.progress)
                                .font(.title)
                                .blendMode(.exclusion)
                                .foregroundColor(.gray)
                                .padding(.bottom,20)
                                /// - For Expanded View it's Not Necessary
                                .opacity(config.animateContent && show ? 0 : 1)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: config.animateContent ? cornerRadius : 18, style: .continuous))
                        .animation(.easeInOut(duration: 0.2), value: config.animateContent)
                        .scaleEffect(config.shrink ? 0.95 : 1)
                        .animation(.easeInOut(duration: 0.25), value: config.shrink)
                        .matchedGeometryEffect(id: animationID, in: namespaceID)
                }
            }
            /// - Adding Gesture
            .gesture(
                LongPressGesture(minimumDuration: 0.3).onEnded({ _ in
                    /// - Adding Little Animation Before Expanding Control
                    expandView()
                }).simultaneously(with: DragGesture().onChanged({ value in
                    if !config.shrink{
                        /// - Converting Offset Into Progress
                        let startLocation = value.startLocation.y
                        let currentLocation = value.location.y
                        let offset = startLocation - currentLocation
                        /// - Converting It Into Progress
                        var progress = (offset / size.height) + config.lastProgress
                        /// - Clipping Progress btw 0 - 1
                        progress = max(0, progress)
                        progress = min(1, progress)
                        config.progress = progress
                    }
                }).onEnded({ value in
                    /// - Saving Last Progress for Continous Flow
                    config.lastProgress = config.progress
                }))
            )
        }
    }
    
    func expandView(){
        config.shrink = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            config.shrink = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                config.expand = true
                haptics(.medium)
            }
        }
    }
}
