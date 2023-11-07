//
//  Extensions.swift
//  PopupImagePicker (iOS)
//
//  Created by Balaji on 25/05/22.
//

import SwiftUI
import Photos

// MARK: Custom Modifier
extension View{
    @ViewBuilder
    func popupImagePicker(show: Binding<Bool>,transition: AnyTransition = .move(edge: .bottom),onSelect: @escaping ([PHAsset])->())->some View{
        self
            .overlay {
                let deviceSize = UIScreen.main.bounds.size
                ZStack{
                    // MARK: BG Blur
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .opacity(show.wrappedValue ? 1 : 0)
                        .onTapGesture {
                            show.wrappedValue = false
                        }
                    
                    if show.wrappedValue{
                        PopupImagePickerView {
                            show.wrappedValue = false
                        } onSelect: { assets in
                            onSelect(assets)
                            show.wrappedValue = false
                        }
                        .transition(transition)
                    }
                }
                .frame(width: deviceSize.width, height: deviceSize.height)
                .animation(.easeInOut, value: show.wrappedValue)
            }
    }
}
