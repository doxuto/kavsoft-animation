//
//  Home.swift
//  iOS16LockScreen
//
//  Created by Balaji on 12/08/22.
//

import SwiftUI
import PhotosUI

struct Home: View {
    @EnvironmentObject var lockscreenModel: LockscreenModel
    var body: some View {
        VStack{
            if let compressedImage = lockscreenModel.compressedImage{
                GeometryReader{proxy in
                    let size = proxy.size
                    
                    Image(uiImage: compressedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                        // IF We Apply Scale To Whole View Then The Time View
                        // Will be Stretching
                        // That's Why We Added Gesture to the Root View
                        // And Applying Scaling Only For the Image
                        .scaleEffect(lockscreenModel.scale)
                        .overlay {
                            if let detectedPerson = lockscreenModel.detectedPerson{
                                TimeView()
                                    .environmentObject(lockscreenModel)
                                
                                // MARK: Placing Over the Normal Image
                                Image(uiImage: detectedPerson)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(lockscreenModel.scale)
                            }
                        }
                }
            }else{
                // MARK: Image Picker
                PhotosPicker(selection: $lockscreenModel.pickedItem, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                    VStack(spacing: 10){
                        Image(systemName: "plus.viewfinder")
                            .font(.largeTitle)
                        
                        Text("Add Image")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .ignoresSafeArea()
        // MARK: Cancel Button
        .overlay(alignment: .topLeading) {
            Button("Cancel"){
                withAnimation(.easeInOut){
                    lockscreenModel.compressedImage = nil
                    lockscreenModel.detectedPerson = nil
                }
                lockscreenModel.scale = 1
                lockscreenModel.lastScale = 0
                lockscreenModel.placeTextAbove = false
            }
            .font(.caption)
            .foregroundColor(.primary)
            .padding(.horizontal)
            .padding(.vertical,8)
            .background {
                Capsule()
                    .fill(.ultraThinMaterial)
            }
            .padding()
            .padding(.top,45)
            .opacity(lockscreenModel.compressedImage == nil ? 0 : 1)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Time View
struct TimeView: View{
    @EnvironmentObject var lockscreenModel: LockscreenModel
    var body: some View{
        HStack(spacing: 6){
            Text(Date.now.convertToString(.hour))
                .font(.system(size: 95))
                .fontWeight(.semibold)
            
            // MARK: Dots
            VStack(spacing: 10){
                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
                
                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
                    // MARK: Logic For Putting Time Behing the Person
                    // We use this Second Dot as a Color Rectifier
                    // So We Will Simply Check the Views This Point to be White
                    // If it Changes to Anyother Color Then We're putting Time View above the Person
                    // When will This Color Change Eventually When youre scaling the image
                    // The Image will goes over it
                    // Thus the white will be disabled
                    // Like this
                    .overlay {
                        GeometryReader{proxy in
                            let rect = proxy.frame(in: .global)
                            
                            Color.clear
                                .preference(key: RectKey.self, value: rect)
                                .onPreferenceChange(RectKey.self) { value in
                                    lockscreenModel.textRect = value
                                }
                        }
                    }
            }
            
            Text(Date.now.convertToString(.minute))
                .font(.system(size: 95))
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .padding(.top,100)
    }
}

// MARK: Date To String Conversion
enum DateFormat: String{
    case hour = "hh"
    case minute = "mm"
    case seconds = "ss"
}

extension Date{
    func convertToString(_ format: DateFormat)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: self)
    }
}

// MARK: Rect Preference Key
struct RectKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
