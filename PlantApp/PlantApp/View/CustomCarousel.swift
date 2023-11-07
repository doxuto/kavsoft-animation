//
//  CustomCarousel.swift
//  MovieAppUI
//
//  Created by Balaji on 08/08/22.
//

import SwiftUI

// MARK: Custom View
// Refactoring Code For Snap Carousel
struct CustomCarousel<Content: View,Item,ID>: View where Item: RandomAccessCollection,ID: Hashable,Item.Element: Equatable {
    var content: (Item.Element,CGSize)->Content
    var id: KeyPath<Item.Element,ID>
    
    // MARK: View Properties
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int
    
    init(index: Binding<Int>,items: Item,spacing: CGFloat = 30,cardPadding: CGFloat = 80,id: KeyPath<Item.Element, ID>,@ViewBuilder content: @escaping (Item.Element,CGSize) -> Content) {
        self.content = content
        self.id = id
        self._index = index
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
    }
    
    // MARK: Gesture Properties
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    
    @State var currentIndex: Int = 0
    // MARK: Rotation
    @State var rotation: Double = 0
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            
            // MARK: Reduced After Applying Card Spacing & Padding
            let cardWidth = size.width - (cardPadding - spacing)
            HStack(spacing: spacing){
                ForEach(items,id: id){movie in
                    // Since We Already Applied Spacing
                    // And Again We're Adding it to Frame
                    // So Simply Removing the Spacing
                    
                    let index = indexOf(item: movie)
                    content(movie,CGSize(width: size.width - cardPadding, height: size.height))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
                }
            }
            .offset(x: offset)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged{onChanged(value: $0, cardWidth: cardWidth)}
                    .onEnded{onEnd(value: $0, cardWidth: cardWidth)}
            )
        }
        .animation(.easeInOut, value: translation == 0)
    }
    
    // MARK: Item Index
    func indexOf(item: Item.Element)->Int{
        let array = Array(items)
        if let index = array.firstIndex(of: item){
            return index
        }
        return 0
    }
    
    func onChanged(value: DragGesture.Value,cardWidth: CGFloat){
        // Limiting Over Scroll
        var translationX = value.translation.width
        translationX = (index == 0 && translationX > 0 ? (translationX / 4) : translationX)
        translationX = (index == items.count - 1 && translationX < 0 ? (translationX / 4) : translationX)
        offset = translationX + lastStoredOffset
    }
    
    func onEnd(value: DragGesture.Value,cardWidth: CGFloat){
        // MARK: Finding Current Index
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)
        
        currentIndex = Int(_index)
        // MARK: Updating Index
        // Note Since We're Moving On Right Side
        // So All Data Will be Negative
        index = -currentIndex
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)){
            // MARK: Removing Extra Space
            // Why /2 -> Because We Need Both Sides Need to Be Visible
            let extraSpace = index == 0 ? 0 : (cardPadding / 2)
            offset = (cardWidth * _index) + extraSpace
        }
        lastStoredOffset = offset
    }
}

struct CustomCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
