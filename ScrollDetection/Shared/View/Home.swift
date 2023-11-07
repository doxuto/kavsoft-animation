//
//  Home.swift
//  ScrollDetection (iOS)
//
//  Created by Balaji on 05/11/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        VStack{
            
            Text("Historical letters")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
                .padding(.top,25)
                .padding(.bottom,30)
            
            // SCrollView...
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 30){
                    
                    // Letters...
                    ForEach(letters){letter in
                        
                        // Letter Card View...
                        LetterCardView(letter: letter)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            // Setting Corrdinate Name SPace...
            .coordinateSpace(name: "SCROLL")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            Color("BG")
                .ignoresSafeArea()
        )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct LetterCardView: View{
    
    var letter: Letter
    
    // ScrollOffset...
    // Retreiving Whole Scroll Frame...
    @State var rect: CGRect = .zero
    
    var body: some View{
        
        VStack(spacing: 15){
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text(letter.date)
                    .font(.title2.bold())
                
                Text(letter.title)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.vertical,10)
            
            // Sample Long Text like Letter....
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                .lineSpacing(11)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
        
            Color.white
                .cornerRadius(6)
        )
        // Masking View to show like the letter is shrinking..
        .mask(
        
            Rectangle()
                .padding(.top,rect.minY < (getIndex() * 50) ? -(rect.minY - (getIndex() * 50)) : 0)
        )
        // Applying offset to show shirnking from bottom...
        .offset(y: rect.minY < (getIndex() * 50) ? (rect.minY - (getIndex() * 50)) : 0)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
        // Stop Backward Scrolling...
        // Why we stopped scrolling here...
        // since we need to show a view like scrolled letter that always need to say on screen not be scrolled...
        .overlay(
        
            ScrolledLetterShape()
            
            ,alignment: .top
        )
        // Separating Each card at a distance of 50....
        .offset(y: rect.minY < (getIndex() * 50) ? -(rect.minY - (getIndex() * 50)) : 0)
        .modifier(OffsetModifier(rect: $rect))
        // No More Letters Text At Last...
        .background(
        
            Text("No More Letters")
                .font(.title.bold())
                .foregroundColor(.gray)
                .opacity(isLast() ? 1 : 0)
            // Applying offset to avoid scrolling...
                .offset(y: rect.minY < 0 ? -rect.minY : 0)
        )
        // Applying bottom padding for last letter to allow scrolling...
        .padding(.bottom,isLast() ? rect.height : 0)
    }
    
    @ViewBuilder
    func ScrolledLetterShape()->some View{
        
        Rectangle()
            .fill(Color.white)
            .frame(height: 30 * getProgress())
            .overlay(
            
                Rectangle()
                    .fill(
                    
                        .linearGradient(.init(colors: [
                        
                            Color.black.opacity(0.1),
                            Color.clear,
                            Color.black.opacity(0.1),
                            Color.black.opacity(0.05)
                            
                        ]), startPoint: .top, endPoint: .bottom)
                    )
                
                ,alignment: .top
            )
            .cornerRadius(3)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
    }
    
    func isLast()->Bool{
        return letters.last == letter
    }
    
    func getIndex()->CGFloat{
        let index = letters.firstIndex { letter in
            return self.letter.id == letter.id
        } ?? 0
        
        return CGFloat(index)
    }
    
    // Retreving Progress...
    func getProgress()->CGFloat{
        let progress = -rect.minY / rect.height
        return (progress > 0 ? (progress < 1 ? progress : 1) : 0)
    }
}
