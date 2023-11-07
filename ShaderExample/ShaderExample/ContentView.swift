//
//  ContentView.swift
//  ShaderExample
//
//  Created by Balaji on 17/06/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var pixellate: CGFloat = 1
    @State private var speed: CGFloat = 1
    @State private var amplitude: CGFloat = 5
    @State private var frequency: CGFloat = 15
    let startDate: Date = .init()
    @State private var enableLayerEffect: Bool = false
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    PixellateView()
                        .navigationTitle("Pixellate")
                } label: {
                    Text("Pixellate")
                }

                NavigationLink {
                    WavesView()
                        .navigationTitle("Waves")
                } label: {
                    Text("Waves")
                }
                
                NavigationLink {
                    GrayScaleView()
                        .navigationTitle("Grayscale")
                } label: {
                    Text("Grayscale")
                }
            }
            .navigationTitle("Shaders Example")
        }
    }
    
    /// Layer Effect Example
    @ViewBuilder
    func GrayScaleView() -> some View {
        VStack {
            Image(.xcode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .layerEffect(
                    .init(
                        function: .init(library: .default, name: "grayscale"),
                        arguments: []
                    ),
                    maxSampleOffset: .zero,
                    isEnabled: enableLayerEffect
                )
            
            Toggle("Enable Grayscale Layer Effect", isOn: $enableLayerEffect)
            
            Spacer()
        }
        .padding()
    }
    
    /// Distortion Effect Examples
    @ViewBuilder
    func PixellateView() -> some View {
        VStack {
            Image(.xcode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .distortionEffect(
                    .init(
                        function: .init(library: .default, name: "pixellate"),
                        arguments: [.float(pixellate)]
                    ),
                    maxSampleOffset: .zero
                )
            
            Slider(value: $pixellate, in: 1...10)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func WavesView() -> some View {
        List {
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                
                Image(.xcode)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .distortionEffect(
                        .init(
                            function: .init(library: .default, name: "wave"),
                            arguments: [
                                .float(time),
                                .float(speed),
                                .float(frequency),
                                .float(amplitude)
                            ]
                        ),
                        maxSampleOffset: .zero
                    )
            }
            
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                
                Text("Hello iJustine")
                    .font(.largeTitle.bold())
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .distortionEffect(
                        .init(
                            function: .init(library: .default, name: "wave"),
                            arguments: [
                                .float(time),
                                .float(speed),
                                .float(frequency),
                                .float(amplitude)
                            ]
                        ),
                        maxSampleOffset: .init(width: .zero, height: 100)
                    )
            }
            
            Section("Speed") {
                Slider(value: $speed, in: 1...15)
            }
            
            Section("Frequency") {
                Slider(value: $frequency, in: 1...50)
            }
            
            Section("Amplitude") {
                Slider(value: $amplitude, in: 1...35)
            }
        }
    }
}

#Preview {
    ContentView()
}
