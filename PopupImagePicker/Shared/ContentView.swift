//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 24/05/22.
//

import SwiftUI
import Photos

struct ContentView: View {
    // MARK: Picker Properties
    @State var showPicker: Bool = false
    @State var pickedImages: [UIImage] = []
    var body: some View {
        NavigationView{
            TabView{
                ForEach(pickedImages,id: \.self){image in
                    GeometryReader{proxy in
                        let size = proxy.size
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .frame(height: 450)
            // MARK: SwiftUI Bug
            // If You Dont Have Any Views Inside Tabview
            // It's Crashing, But not in Never
            .tabViewStyle(.page(indexDisplayMode: pickedImages.isEmpty ? .never : .always))
            .navigationTitle("Popup Image Picker")
            .toolbar {
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .popupImagePicker(show: $showPicker) { assets in
            // MARK: Do Your Operation With PHAsset
            // I'm Simply Extracting Image
            // .init() Means Exact Size of the Image
            let manager = PHCachingImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            DispatchQueue.global(qos: .userInteractive).async {
                assets.forEach { asset in
                    manager.requestImage(for: asset, targetSize: .init(), contentMode: .default, options: options) { image, _ in
                        guard let image = image else {return}
                        DispatchQueue.main.async {
                            self.pickedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
