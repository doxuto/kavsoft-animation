//
//  ImageColorPickerHelper.swift
//  ImageColorPicker (iOS)
//
//  Created by Balaji on 13/01/23.
//

import SwiftUI

// MARK: Image Color Picker
fileprivate struct ImageColorPickerHelper: View{
    @Binding var showPicker: Bool
    @Binding var color: Color
    // Image Picker Value
    @State var showImagePicker: Bool = false
    @State var imageData: Data = .init(count: 0)
    
    var body: some View{
        NavigationView{
            VStack(spacing: 10){
                // MARK: Image Picker View
                GeometryReader{proxy in
                    let size = proxy.size
                    
                    VStack(spacing: 12){
                        if let image = UIImage(data: imageData){
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                        }
                        else{
                            Image(systemName: "plus")
                                .font(.system(size: 35))
                            
                            Text("Tap to add Image")
                                .font(.system(size: 14, weight: .light))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Show Image Picker
                        showImagePicker.toggle()
                    }
                }
                
                ZStack(alignment: .top){
                    // Displaying the Selected Color
                    Rectangle()
                        .fill(color)
                        .frame(height: 90)
                    
                    // Since we need only Live picker button
                    // Simply setting the height of the picker to 50
                    // And clipping the remaining content
                    // So that the top Bar will only Appear
                    CustomColorPicker(color: $color)
                    // Centering It
                        .frame(width: 100,height: 50,alignment: .topLeading)
                        .clipped()
                        .offset(x: 20)
                        .overlay(alignment: .trailing, content: {
                            Text(UIColor(color).hexString ?? "")
                                .foregroundColor(UIColor(color).isDarkColor ? .white : .black)
                                .textSelection(.enabled)
                                .offset(x: 45)
                        })
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationTitle("Image Color Picker")
            .navigationBarTitleDisplayMode(.inline)
            // MARK: Close Button
            .toolbar {
                Button("Close"){
                    showPicker.toggle()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(showPicker: $showImagePicker, imageData: $imageData)
            }
        }
    }
}

// MARK: Making extension to call Image Color Picker
extension View{
    func imageColorPicker(showPicker: Binding<Bool>,color: Binding<Color>)->some View{
        return self
        // Full Sheet
            .fullScreenCover(isPresented: showPicker){
                ImageColorPickerHelper(showPicker: showPicker, color: color)
            }
    }
}
