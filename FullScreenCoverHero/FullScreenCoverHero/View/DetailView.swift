//
//  DetailView.swift
//  FullScreenCoverHero
//
//  Created by Balaji on 05/02/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var row: Row
    var animationID: Namespace.ID
    /// View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var animateHeroView: Bool = false
    @State private var animateContent: Bool = false
    @State private var completionValue: CGFloat = 0.0
    var body: some View {
        VStack{
            if animateHeroView {
                Rectangle()
                    .fill(row.color.gradient)
                    .matchedGeometryEffect(id: row.id.uuidString, in: animationID)
                    .frame(width: 200, height: 200)
                    /// Adding Transition for Solid Animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(x: 10, y: 10)))
            } else {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 200, height: 200)
            }
            
            Text("Hello it's fullscreenCover(..)")
                .padding(.top,10)
                .opacity(animateContent ? 1 : 0)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(content: {
            Color.white
                .ignoresSafeArea()
                .opacity(animateContent ? 1 : 0)
        })
        .overlay(alignment: .topLeading) {
            Button {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animateContent = false
                    animateHeroView = false
                    row = .init(color: .clear)
                    completionValue = 1.0
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            .padding(15)
            .opacity(animateContent ? 1 : 0)
            .modifier(AnimationCompletionObserver(observedValue: completionValue, completion: {
                dismiss()
            }))
        }
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                animateContent = true
                animateHeroView = true
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
