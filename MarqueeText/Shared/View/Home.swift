//
//  Home.swift
//  MarqueeText (iOS)
//
//  Created by Balaji on 26/01/22.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView{
            
            VStack(alignment: .leading, spacing: 22) {
                
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    // MARK: Sample Image
                    Image("Post")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(15)
                }
                .frame(height: 220)
                .padding(.horizontal)
                
                Marquee(text: "Tech, video games, failed cooking attempts, vlogs and more!",font: .systemFont(ofSize: 22, weight: .regular))
            }
            .padding(.vertical)
            .navigationTitle("Marquee Text")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Marquee Text View
struct Marquee: View{
    
    @State var text: String
    // MARK: Customimazation Options
    var font: UIFont
    
    // Storing Text Size
    @State var storedSize: CGSize = .zero
    // MARK: Animation Offset
    @State var offset: CGFloat = 0
    
    // MARK: Animation Speed
    var animationSpeed: Double = 0.015
    var delayTime: Double = 0.8
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        // Since it scrolls horizontal using ScrollView
        ScrollView(.horizontal, showsIndicators: false) {
            
            Text(text)
                .font(Font(font))
                .offset(x: offset)
                .padding(.horizontal,15)
        }
        // MARK: Opacity Effect
        .overlay(content: {
            
            HStack{
                
                let color: Color = scheme == .dark ? .black : .white
                
                LinearGradient(colors: [color,color.opacity(0.7),color.opacity(0.5),color.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
                
                Spacer()
                
                LinearGradient(colors: [color,color.opacity(0.7),color.opacity(0.5),color.opacity(0.3)].reversed(), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
            }
        })
        // Disbaling Manual Scrolling
        .disabled(true)
        .onAppear {
            
            // Base Text
            let baseText = text
            
            // MARK: Continous Text Animation
            // Adding Spacing For Continous Text
            (1...15).forEach { _ in
                text.append(" ")
            }
            // Stoping Animation exactly before the next text
            storedSize = textSize()
            text.append(baseText)
            
            // Calculating Total Secs based on Text Width
            // Our Animation Speed for Each Character will be 0.02s
            let timing: Double = (animationSpeed * storedSize.width)
            
            // Delaying FIrst Animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                withAnimation(.linear(duration: timing)){
                    offset = -storedSize.width
                }
            }
        }
        // MARK: Repeating Marquee Effect with the help of Timer
        // Optional: If you want some dalay for next animation
        .onReceive(Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime), on: .main, in: .default).autoconnect()) { _ in
            
            // Resetting offset to 0
            // Thus its look like its looping
            offset = 0
            withAnimation(.linear(duration: (animationSpeed * storedSize.width))){
                offset = -storedSize.width
            }
        }
    }
    
    // MARK: Fetching Text Size for Offset Animation
    func textSize()->CGSize{
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
