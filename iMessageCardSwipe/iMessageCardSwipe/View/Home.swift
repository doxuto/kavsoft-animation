//
//  Home.swift
//  iMessageCardSwipe
//
//  Created by Balaji on 01/10/22.
//

import SwiftUI

struct Home: View {
    // MARK: Sample Messages With Image
    // NOTE: Your Model Need to Conform Equatable
    @State var messages: [Message] = []
    var body: some View {
        VStack{
            SwipeCarousel(items: messages, id: \.id) { message,size in
                // YOUR CUSTOM VIEW GOES HERE
                Image(message.imageFile)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            // Mention Your Card Size
            // Otherwise It Will Occpie Entire Screen
            .frame(width: 220, height: 300)
        }
        .onAppear {
            // MARK: Creating Sample Messages
            for index in 1...5{
                messages.append(Message(imageFile: "Pic\(index)"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Custom View
struct SwipeCarousel<Content: View,ID,Item>: View where Item: RandomAccessCollection,Item.Element: Equatable,Item.Element: Identifiable,ID: Hashable{
    
    var id: KeyPath<Item.Element,ID>
    var items: Item
    // MARK: Creating a Custom View like ForEach
    var content: (Item.Element,CGSize)->Content
    var trailingCards: Int = 3
    
    init(items: Item,id: KeyPath<Item.Element, ID>,trailingCards: Int = 3, @ViewBuilder content: @escaping (Item.Element,CGSize) -> Content) {
        self.id = id
        self.items = items
        self.content = content
        self.trailingCards = trailingCards
    }
    
    // MARK: View/Gesture Properties
    @State var offset: CGFloat = 0
    @State var showRight: Bool = false
    @State var currentIndex: Int = 0
    
    var body: some View{
        GeometryReader{
            let size = $0.size
            
            ZStack{
                // No Need to Use .reversed()
                // Instead Use ZIndex
                ForEach(items){item in
                    CardView(item: item, size: size)
                        // MARK: If User Starts Swipe Right
                        // Then We're going to Showing The Last Swiped Card as a Overlay
                        .overlay(content: {
                            let index = indexOf(item: item)
                            if (currentIndex + 1) == index && Array(items).indices.contains(currentIndex - 1) && showRight{
                                CardView(item: Array(items)[currentIndex - 1], size: size)
                                    .transition(.identity)
                            }
                        })
                        .zIndex(zIndexFor(item: item))
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        showRight = (value.translation.width > 0)
                        offset = (value.translation.width / (size.width + 30)) * size.width
                    })
                    .onEnded({ value in
                        let translation = value.translation.width
                        
                        if translation > 0{
                            // MARK: Swipe Right
                            decreaseIndex(translation: translation)
                        }else{
                            // MARK: Swipe Left
                            increaseIndex(translation: translation)
                        }
                        
                        withAnimation(.easeInOut(duration: 0.25)){
                            offset = .zero
                        }
                    })
            )
        }
    }
    
    @ViewBuilder
    func CardView(item: Item.Element,size: CGSize)->some View{
        let index = indexOf(item: item)
        content(item,size)
            // MARK: Shadow
            .shadow(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)
            .scaleEffect(scaleFor(item: item))
            .offset(x: offsetFor(item: item))
            .rotationEffect(.init(degrees: rotationFor(item: item)), anchor: currentIndex > index ? .topLeading : .topTrailing)
            // MARK: Only Adding Gesture Value To the CurrentCard
            .offset(x: currentIndex == index ? offset : 0)
            .rotationEffect(.init(degrees: rotationForGesture(index: index)), anchor: .top)
            .scaleEffect(scaleForGesture(index: index))
    }
    
    // MARK: Swapping Cards
    func increaseIndex(translation: CGFloat){
        if translation < 0 && -translation > 110 && currentIndex < (items.count - 1){
            withAnimation(.easeInOut(duration: 0.25)){
                currentIndex += 1
            }
        }
    }
    
    func decreaseIndex(translation: CGFloat){
        if translation > 0 && translation > 110 && currentIndex > 0{
            withAnimation(.easeInOut(duration: 0.25)){
                currentIndex -= 1
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                showRight = false
            }
        }
    }
    
    // MARK: Gesture Based Rotation And Scaling Values
    func rotationForGesture(index: Int)->CGFloat{
        // CHANGE WITH YOUR OWN VALUES HERE
        let progress = (offset / screenSize.width) * 30
        return (currentIndex == index ? progress : 0)
    }
    
    func scaleForGesture(index: Int)->CGFloat{
        // To avoid Over Sizing when it goes to Negative
        let progress = 1 - ((offset > 0 ? offset : -offset) / screenSize.width)
        return (currentIndex == index ? (progress > 0.75 ? progress : 0.75) : 1)
    }
    
    // Since We Need to Move the Swiped Card Away
    // Just Simply Eliminate Current Index From the Index in all the Methods Here
    // MARK: Applying Offsets,Scaling And Rotation For Each Based on Index
    
    // EG: 0 - 1 = -1
    // So We Need to Check for Negative Values
    func offsetFor(item: Item.Element)->CGFloat{
        let index = indexOf(item: item) - currentIndex
        if index > 0{
            if index > trailingCards{
                return 20 * CGFloat(trailingCards)
            }
            return CGFloat(index) * 20
        }
        if -index > trailingCards{
            return -20 * CGFloat(trailingCards)
        }
        return CGFloat(index) * 20
    }
    
    func scaleFor(item: Item.Element)->CGFloat{
        let index = indexOf(item: item) - currentIndex
        if index > 0{
            if index > trailingCards{
                return 1 - (CGFloat(trailingCards) / 20)
            }
            // MARK: For Each Card I'm going to Decrease 0.05 Scaling (It's Your Own Custom Value)
            return 1 - (CGFloat(index) / 20)
        }
        if -index > trailingCards{
            return 1 - (CGFloat(trailingCards) / 20)
        }
        // MARK: For Each Card I'm going to Decrease 0.05 Scaling (It's Your Own Custom Value)
        return 1 + (CGFloat(index) / 20)
    }
    
    func rotationFor(item: Item.Element)->CGFloat{
        let index = indexOf(item: item) - currentIndex
        if index > 0{
            if index > trailingCards{
                return CGFloat(trailingCards) * 3
            }
            // MARK: For Each Card I'm going to Rotate 3deg (It's Your Own Custom Value)
            return CGFloat(index) * 3
        }
        if -index > trailingCards{
            return -CGFloat(trailingCards) * 3
        }
        // MARK: For Each Card I'm going to Rotate 3deg (It's Your Own Custom Value)
        return CGFloat(index) * 3
    }
    
    // MARK: ZIndex Value For Each Card
    func zIndexFor(item: Item.Element)->Double{
        let index = indexOf(item: item)
        let totalCount = items.count
        
        // Placing the Current Index At Top Of all the Items
        return currentIndex == index ? 10 : (currentIndex < index ? Double(totalCount - index) : Double(index - totalCount))
    }
    
    // MARK: Index For Each Card
    func indexOf(item: Item.Element)->Int{
        let arrayItems = Array(items)
        if let index = arrayItems.firstIndex(of: item){
            return index
        }
        return 0
    }
    
    // MARK: Current iPhone Screen Size
    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        return window.screen.bounds.size
    }()
}
