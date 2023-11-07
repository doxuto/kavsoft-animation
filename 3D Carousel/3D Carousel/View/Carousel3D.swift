//
//  Carousel3D.swift
//  3D Carousel
//
//  Created by Balaji on 28/10/22.
//

import SwiftUI

// MARK: Custom View
struct Carousel3D<Content: View,ID,Item>: View where Item: RandomAccessCollection,Item.Element: Identifiable,Item.Element: Equatable,ID: Hashable {
    var cardSize: CGSize
    var items: Item
    var id: KeyPath<Item.Element,ID>
    var content: (Item.Element)->Content
    
    var hostingViews: [UIView] = []
    
    // MARK: Gesture Properties
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @State var animationDuration: CGFloat = 0
    
    init(cardSize: CGSize, items: Item, id: KeyPath<Item.Element, ID>, @ViewBuilder content: @escaping (Item.Element) -> Content) {
        self.cardSize = cardSize
        self.items = items
        self.id = id
        self.content = content
        
        for item in items{
            let hostingView = convertToUIView(item: item).view!
            hostingViews.append(hostingView)
        }
    }
    
    var body: some View {
        CarouselHelper(views: hostingViews, cardSize: cardSize, offset: offset, animationDuration: animationDuration)
            .frame(width: cardSize.width, height: cardSize.height)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        animationDuration = 0
                        // MARK: Slowing Down
                        offset = (value.translation.width * 0.35) + lastStoredOffset
                    }).onEnded({ value in
                        guard items.count > 0 else{
                            lastStoredOffset = offset
                            return
                        }
                        
                        // MARK: Adding Animation
                        animationDuration = 0.2
                        let anglePerCard = 360.0 / CGFloat(items.count)
                        offset = CGFloat(Int((offset / anglePerCard).rounded())) * anglePerCard
                        lastStoredOffset = offset
                    })
            )
            .onChange(of: items.count) { newValue in
                guard newValue > 0 else{return}
                // MARK: Animating When Item is Removed or Inserted
                animationDuration = 0.2
                let anglePerCard = 360.0 / CGFloat(newValue)
                offset = CGFloat(Int((offset / anglePerCard).rounded())) * anglePerCard
                lastStoredOffset = offset
            }
    }
    
    // MARK: Converting SwiftUI View Into UIKit View
    func convertToUIView(item: Item.Element)->UIHostingController<Content>{
        let hostingView = UIHostingController(rootView: content(item))
        hostingView.view.frame.origin = .init(x: cardSize.width / 2, y: cardSize.height / 2)
        hostingView.view.backgroundColor = .clear
        
        return hostingView
    }
}

struct Carousel3D_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: UIKit UnWrapper
fileprivate
struct CarouselHelper: UIViewRepresentable{
    var views: [UIView]
    var cardSize: CGSize
    var offset: CGFloat
    var animationDuration: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // MARK: Adding Views as SubViews
        // Only Adding Single Time
        // Since We Need Cards to Form a Circle Shape
        let circleAngle = 360.0 / CGFloat(views.count)
        var angle: CGFloat = offset
        
        if uiView.subviews.count > views.count{
            // MARK: Remove Last Sub View
            uiView.subviews[uiView.subviews.count - 1].removeFromSuperview()
        }
        
        for (view,index) in zip(views, views.indices){
            if uiView.subviews.indices.contains(index){
                // ALREADY ADDED
                // SINCE IT"S ALREADY ADDED SO DO THE MODIFICATIONS HERE
                apply3DTransform(view: uiView.subviews[index], angle: angle)
                
                // MARK: We Need Disable All Other Card Rather Than Our Center To Enable Proper Button/Taps
                // Because It Can Increase 360 For Each Complete Turn
                // Reducing Complet Turns
                let completeRotation = CGFloat(Int(angle / 360)) * 360.0
                if (angle - completeRotation) == 0{
                    uiView.subviews[index].isUserInteractionEnabled = true
                }else{
                    uiView.subviews[index].isUserInteractionEnabled = false
                }
                
                angle += circleAngle
            }else{
                // ADD FOR THE FIRST TIME
                let hostView = view
                hostView.frame = .init(origin: .zero, size: cardSize)
                
                uiView.addSubview(hostView)
                
                apply3DTransform(view: uiView.subviews[index], angle: angle)
                angle += circleAngle
            }
        }
    }
    
    func apply3DTransform(view: UIView,angle: CGFloat){
        // MARK: Adding 3D Transform
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / 500
        
        // MARK: Calculating Angle
        
        // MARK: Transform Uses Radians
        transform3D = CATransform3DRotate(transform3D, degToRad(deg: angle), 0, 1, 0)
        transform3D = CATransform3DTranslate(transform3D, 0, 0, cardSize.width)
            
        UIView.animate(withDuration: animationDuration) {
            view.transform3D = transform3D
        }
    }
}

func degToRad(deg: CGFloat)->CGFloat{
    return (deg * .pi) / 180
}
