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
                
                Marquee(text: "Tech, video games, cooking, vlogs and more! ",font: .systemFont(ofSize: 22, weight: .regular))
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
    
    var text: String
    // MARK: Customimazation Options
    var font: UIFont
    
    // Storing Text Size
    @State var storedSize: CGSize = .zero
    // MARK: Animation Offset
    @State var offset: CGFloat = 0
    // MARK: Updated Text
    @State var animatedText: String = ""
    
    // MARK: Animation Speed
    var animationSpeed: Double = 0.015
    var delayTime: Double = 0.8
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        // Since it scrolls horizontal using ScrollView
        GeometryReader{proxy in
            
            let size = proxy.size
            
            let condition = textSize(text: text).width < (size.width - 50)
            
            ScrollView(condition ? .init() : .horizontal, showsIndicators: false) {
                
                Text(condition ? text : animatedText)
                    .font(Font(font))
                    .offset(x: condition ? 0 : offset)
                    .padding(.horizontal,15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
        }
        .frame(height: storedSize.height)
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
        .onAppear{
            startAnimation(text: text)
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
        // MARK: Re-calculating text size when text is changed
        .onChange(of: text) { newValue in
            animatedText = ""
            offset = 0
            startAnimation(text: newValue)
        }
    }
    
    // MARK: Starting Animation
    func startAnimation(text: String){
        
        // MARK: Continous Text Animation
        // Adding Spacing For Continous Text
        animatedText.append(text)
        (1...15).forEach { _ in
            animatedText.append(" ")
        }
        // Stoping Animation exactly before the next text
        storedSize = textSize(text: animatedText)
        animatedText.append(text)
        
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
    
    // MARK: Fetching Text Size for Offset Animation
    func textSize(text: String)->CGSize{
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
