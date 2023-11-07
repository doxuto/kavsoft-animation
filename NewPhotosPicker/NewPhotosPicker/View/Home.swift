//
//  Home.swift
//  NewPhotosPicker
//
//  Created by Balaji on 24/06/22.
//

import SwiftUI
import PhotosUI

struct Home: View {
    // MARK: State Object
    @StateObject var photosModel: PhotosPickerModel = .init()
    var body: some View {
        NavigationStack{
            VStack{
                if !photosModel.loadedImages.isEmpty{
                    TabView{
                        ForEach(photosModel.loadedImages){mediaFile in
                            mediaFile.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 250)
                }
            }
            .navigationTitle("Photos Picker")
            .toolbar {
                // MARK: New Photos Picker Button
                // MARK: Your Custom Filter
                // For Some Reason It Won't Work On Simulator
                // Note: It's Still In Beta
                // Test it With Real Device
                
                // Another Bug: If We Didn't Mention Photo LIbrary it's Not Working
                PhotosPicker(selection: $photosModel.selectedPhoto, matching: .any(of: [.images]),photoLibrary: .shared()) {
                    Image(systemName: "photo.fill")
                        .font(.callout)
                }
                
                PhotosPicker(selection: $photosModel.selectedPhotos, matching: .any(of: [.images]),photoLibrary: .shared()) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.callout)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
