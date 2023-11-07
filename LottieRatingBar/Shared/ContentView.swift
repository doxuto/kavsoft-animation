//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 11/11/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {

        RatingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RatingView: View{
    
    // Gesture Properties...
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    @State var currentSliderProgress: CGFloat = 0.5
    
    var body: some View{
        
        VStack(spacing: 15){
            
            Text(getAttributedString())
                .font(.system(size: 45))
                .fontWeight(.medium)
                .kerning(1.1)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                LottieAnimationView(jsonFile: "Rating", progress: $currentSliderProgress)
                    .frame(width: size.width, height: size.height)
                    .scaleEffect(1.4)
            }
            
            // Slider...
            ZStack{
                
                Rectangle()
                    .fill(.white)
                    .frame(height: 1)
                
                Group{
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black)
                        .frame(width: 55, height: 55)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 11, height: 11)
                }
                // So as to return the correct screen location...
                .frame(maxWidth: .infinity,alignment: .center)
                .contentShape(Rectangle())
                .offset(x: offset)
                // Gesture...
                .gesture(
                
                    DragGesture(minimumDistance: 5)
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            
                            // removing half width value to get correct translation..
                            // 30 = Horizontal Padding...
                            let width = UIScreen.main.bounds.width - 30
                            
                            var translation = value.location.x
                            
                            // Stopping at start and stop...
                            // Since total area = 55
                            // So stopping at half of total area
                            // ie: 55/2 => 27...
                            
                            translation = (translation > 27 ? translation : 27)
                            
                            translation = (translation < (width - 27) ? translation : (width - 27))
                            
                            translation = isDragging ? translation : 0
                            
                            offset = translation - (width / 2)
                            
                            // converting it to progress....
                            let progress = (translation - 27) / (width - 55)
                            
                            currentSliderProgress = progress
                        })
                )
            }
            .padding(.bottom,20)
            .offset(y: -10)
              
            Button {
                
                // printing starts...
                let star = (currentSliderProgress / 0.2).rounded()
                
                print(star)
                
            } label: {
                
                Text("Done 👍")
                    .font(.title3)
                    .fontWeight(.medium)
                    .kerning(1.1)
                    .padding(.vertical,18)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(
                    
                        Color.black,in: RoundedRectangle(cornerRadius: 18)
                    )
            }
            .padding(.horizontal,15)

        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            LinearGradient(colors: [
            
                Color("BG1"),
                Color("BG2"),
                Color("BG2"),
                Color("BG2"),
                Color("BG3"),
                Color("BG3"),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .overlay(
        
            Button(action: {
                
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
            })
                .padding(.trailing)
                .padding(.top)
            
            ,alignment: .topTrailing
        )
    }
    
    // Attributed String...
    func getAttributedString()->AttributedString{
        
        var str = AttributedString("How was \nyour Food?")
        
        if let range = str.range(of: "Food?"){
            str[range].foregroundColor = .white
        }
        
        return str
    }
}
