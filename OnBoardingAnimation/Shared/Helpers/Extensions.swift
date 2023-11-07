//
//  Extensions.swift
//  OnBoardingAnimation (iOS)
//
//  Created by Balaji on 08/02/22.
//

import SwiftUI

extension View{
    
    // MARK: Custom Spotlight Modifier
    func spotlight(enabled: Bool,title: String = "")->some View{
        return self
            .overlay {
                if enabled{
                    // To Get the Current Content Size
                    GeometryReader{proxy in
                        let rect = proxy.frame(in: .global)
                        
                        SpotlightView(rect: rect,title: title) {
                            self
                        }
                    }
                }
            }
    }
    
    // MARK: Screen Bounds
    func screenBounds()->CGRect{
        return UIScreen.main.bounds
    }
    
    // MARK: Root Controller
    func rootController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}

struct OnBoarding_Spotlight_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}

// MARK: Spotlight View
struct SpotlightView<Content: View>: View{
    
    var content: Content
    var rect: CGRect
    var title: String
    
    init(rect: CGRect,title: String,@ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self.title = title
        self.rect = rect
    }
    
    @State var tag: Int = 1009
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        Rectangle()
        // If you want to avoid user interaction
            .fill(.white.opacity(0.02))
            .onAppear {
                addOverlayView()
            }
            .onDisappear {
                removeOverlay()
            }
    }
    
    // MARK: Removing the overlay when the view disappeared
    func removeOverlay(){
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag{
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: Adding An Extra View over the Current View
    // By extracting the UIView from Root Controller
    func addOverlayView(){
        
        // Converting SwiftUI View to UIKit
        let hostingView = UIHostingController(rootView: overlaySwiftUIView())
        hostingView.view.frame = screenBounds()
        hostingView.view.backgroundColor = .clear
        
        
        // To identiy which View added, adding a tag to the View
        // Some times SwiftUI On Appear will be called Twice
        // to avoid adding two times
        if self.tag == 1009{
            self.tag = generateRandom()
        }
        hostingView.view.tag = self.tag
        
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag{return}
        }
        // Adding to the Current View
        rootController().view.addSubview(hostingView.view)
    }
    
    @ViewBuilder
    func overlaySwiftUIView()->some View{
        ZStack{
            
            Rectangle()
                .fill(Color("Spotlight").opacity(scheme == .dark ? 0.9 : 0.8))
            // Reverse masking the Current Highlight Spot
                .mask({
                    
                    // If height and width almost same then making it circle else, Rounded
                    let radius = (rect.height / rect.width) > 0.7 ? rect.width : 6
                    
                    Rectangle()
                        .overlay {
                            content
                                .frame(width: rect.width, height: rect.height)
                            // Little Extra high light area
                                .padding(10)
                                .background(.white,in: RoundedRectangle(cornerRadius: radius))
                            // Placing at right Place
                                .position()
                            // Position will place the content at the Top left
                            // With the help of MidX&Y we can set it at correct position
                                .offset(x: rect.midX, y: rect.midY)
                            // The Exact content Size
                                .blendMode(.destinationOut)
                        }
                })
            
            // Displaying Text
            if title != ""{
                Text(title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .position()
                // If its bottom then showing text above or showing below
                    .offset(x: screenBounds().midX, y: rect.maxY > (screenBounds().height - 150) ? (rect.minY - 150) : (rect.maxY + 150))
                    .padding()
                    .lineLimit(2)
            }
        }
        .frame(width: screenBounds().width, height: screenBounds().height)
        .ignoresSafeArea()
    }
    
    // MARK: Random Number for Tag
    func generateRandom()->Int{
        let random = Int(UUID().uuid.0)
        
        // Checking if there is a view already having this tag
        let subViews = rootController().view.subviews
        
        for index in subViews.indices{
            if subViews[index].tag == random{
                return generateRandom()
            }
        }
        
        return random
    }
}
