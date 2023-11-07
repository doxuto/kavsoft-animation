//
//  Home.swift
//  SequencedAnimation
//
//  Created by Balaji on 04/11/22.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var startAnimation: Bool = false
    @State var animateContent: Bool = false
    @State var animateText: [Bool] = [false,false]
    @State var backgroundWidth: CGFloat? = 60
    var body: some View {
        VStack(spacing: 15){
            HeaderView()
            
            CardView()
                .padding(.top,10)
                .zIndex(1)
            
            DetailCardView()
                .zIndex(0)
            
            CardView(cardColor: Color("Orange"),spent: "7821.25",cardNumber: "9813",cardIndex: 1)
        }
        .padding(15)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .background {
            Color("BG")
                .frame(width: backgroundWidth)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .ignoresSafeArea()
        }
        .overlay(alignment: .trailing, content: {
            HStack(spacing: 10){
                Text("My Cards")
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 19))
            .fontWeight(.semibold)
            .contentShape(Rectangle())
            .onTapGesture {
                animatePage()
            }
            .rotationEffect(.init(degrees: -90))
            .offset(x: startAnimation ? 120 : 22)
            .opacity(startAnimation ? 0 : 1)
        })
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
    
    // MARK: Animating Wallet Page
    func animatePage(){
        withAnimation(.easeInOut(duration: 0.4)){
            backgroundWidth = 40
        }
        
        withAnimation(.interactiveSpring(response: 1.1, dampingFraction: 0.75, blendDuration: 0).delay(0.3)){
            backgroundWidth = nil
            startAnimation = true
        }
        
        // MARK: Enabling Rolling Counters
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15){
            animateText[0] = true
            animateText[1] = true
        }
    }
    
    // MARK: Detail Card View
    @ViewBuilder
    func DetailCardView()->some View{
        VStack(alignment: .leading, spacing: 12) {
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("$695.50")
                .font(.title.bold())
                .foregroundColor(.white)
                .offset(x: startAnimation ? 0 : 100)
                .opacity(startAnimation ? 1 : 0)
                .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.9, blendDuration: 1).delay(1.5), value: startAnimation)
            
            HStack{
                Button {
                    
                } label: {
                    Text("Manage")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .padding(.horizontal,25)
                        .background {
                            Capsule()
                                .stroke(.white, lineWidth: 1)
                        }
                }

                Button {
                    
                } label: {
                    Text("Pay Now")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.vertical,10)
                        .padding(.horizontal,25)
                        .background {
                            Capsule()
                                .fill(.white)
                        }
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,12)
            .offset(y: startAnimation ? 0 : 100)
            .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.9, blendDuration: 1).delay(1.8), value: startAnimation)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                
            } label: {
                Text("Due")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Orange"))
                    .underline(true, color: Color("Orange"))
            }
            .padding(15)
            .offset(x: startAnimation ? 0 : -100)
            .opacity(startAnimation ? 1 : 0)
            .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.9, blendDuration: 1).delay(1.7), value: startAnimation)
        }
        .padding(15)
        .background(Color("Tab"))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.vertical,10)
        // MARK: Animating Detail Card
        .rotation3DEffect(.init(degrees: startAnimation ? 0 : 30), axis: (x: 1, y: 0, z: 0))
        .offset(y: startAnimation ? 0 : -200)
        .opacity(startAnimation ? 1 : 0)
        .animation(.interactiveSpring(response: 1, dampingFraction: 0.9, blendDuration: 1).delay(1.2), value: startAnimation)
    }
    
    // MARK: Card View
    // Both Cards Animating At Same Time, With the Help of Index We can Slow Down the Sub Sequent Cards Animation Timing
    @ViewBuilder
    func CardView(cardColor: Color = .white,spent: String = "5421.80",cardNumber: String = "3667",cardIndex: CGFloat = 0)->some View{
        let extraDelay: CGFloat = (cardIndex / 3.5)
        // Simply Add this Delay to All the Exisiting Delay Animations
        
        VStack(alignment: .leading, spacing: 15){
            Image("Mastercard-Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
                .offset(x: startAnimation ? 0 : 15, y: startAnimation ? 0 : 15)
                .opacity(startAnimation ? 1 : 0)
                .animation(.easeInOut(duration: 1).delay(1 + extraDelay), value: startAnimation)
            
            HStack(spacing: 4){
                Text("$")
                    .font(.title.bold())
                // MARK: Rolling Text
                // See My Rolling Text Video, Link in the Video Description
                
                let separatedString: [String] = spent.components(separatedBy: ".")
                
                if separatedString.indices.contains(0),animateText[0]{
                    RollingText(font: .title, weight: .bold, value: .constant(NSString(string: separatedString[0]).integerValue),animationDuration: 1.5)
                        .transition(.opacity)
                }
                
                Text(".")
                    .font(.title.bold())
                    .padding(.horizontal,-4)
                
                if separatedString.indices.contains(1),animateText[1]{
                    RollingText(font: .title, weight: .bold, value: .constant(NSString(string: separatedString[1]).integerValue),animationDuration: 1.5)
                        .transition(.opacity)
                }
            }
            .opacity(startAnimation ? 1 : 0)
            .animation(.easeInOut(duration: 1).delay(1.2 + extraDelay), value: startAnimation)
            .frame(maxWidth: .infinity,alignment: .leading)
            .overlay(alignment: .trailing) {
                CVVView()
                    .opacity(startAnimation ? 1 : 0)
                    .offset(x: startAnimation ? 0 : 70)
                    .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(1.6), value: startAnimation)
            }
            
            Text("Balance")
                .fontWeight(.semibold)
                .foregroundColor(Color("Tab"))
                .opacity(startAnimation ? 1 : 0)
                .offset(y: startAnimation ? 0 : 70)
                .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(1.5 + extraDelay), value: startAnimation)
            
            HStack{
                Text("****   ****   ****")
                    .font(.title)
                    .fontWeight(.semibold)
                    .kerning(3)
                
                Text("  " + cardNumber)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .offset(y: -6)
            }
            .lineLimit(1)
            .opacity(startAnimation ? 1 : 0)
            .offset(y: startAnimation ? 0 : 70)
            .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(1.6 + extraDelay), value: startAnimation)
        }
        .foregroundColor(.black)
        .padding(15)
        .padding(.horizontal,10)
        .frame(maxWidth: .infinity)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        // MARK: Animating Card
        .rotation3DEffect(.init(degrees: startAnimation ? 0 : -70), axis: (x: 1, y: 0, z: 0), anchor: .center)
        .scaleEffect(startAnimation ? 1 : 0.001, anchor: .bottom)
        .animation(.interactiveSpring(response: 1, dampingFraction: 0.7, blendDuration: 1).delay(0.9 + extraDelay), value: startAnimation)
    }
    
    // MARK: CVV View
    @ViewBuilder
    func CVVView()->some View{
        HStack(spacing: 5){
            ForEach(1...3,id: \.self){_ in
                Circle()
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.trailing,8)
    }
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView()->some View{
        HStack{
            Text("My Cards")
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,alignment: .leading)
                .opacity(startAnimation ? 1 : 0)
                .offset(x: startAnimation ? 0 : 100)
                .animation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(0.9), value: startAnimation)
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(Color("BG"))
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white)
                    }
            }
            .scaleEffect(startAnimation ? 1 : 0.001)
            .animation(.interactiveSpring(response: 1, dampingFraction: 0.6, blendDuration: 0.7).delay(0.7), value: startAnimation)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
