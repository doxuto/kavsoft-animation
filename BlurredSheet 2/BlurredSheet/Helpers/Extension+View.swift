//
//  Extension+View.swift
//  BlurredSheet
//
//  Created by Balaji on 14/12/22.
//

import SwiftUI

extension View{
    // MARK: Custom View Modifier
    func blurredSheet<Content: View>(_ style: AnyShapeStyle,show: Binding<Bool>,onDismiss: @escaping ()->(),@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .sheet(isPresented: show, onDismiss: onDismiss) {
                if #available(iOS 16.4, *) {
                    content()
                        .presentationBackground(style)
                } else {
                    content()
                        .background(RemovebackgroundColor())
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background {
                            Rectangle()
                                .fill(style)
                                .ignoresSafeArea(.container, edges: .all)
                        }
                }
            }
    }
}

// MARK: Helper View
fileprivate struct RemovebackgroundColor: UIViewRepresentable{
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
