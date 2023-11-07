//
//  Home.swift
//  PizzaAnimation
//
//  Created by Balaji on 03/07/22.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var selectedPizza: Pizza = pizzas[0]
    @State var swipeDirection: Alignment = .center
    @State var animatePizza: Bool = false
    @State var pizzaSize: String = "MEDIUM"
    @Namespace var animation
    var body: some View {
        VStack{
            HStack{
                Button {
                    
                } label: {
                    Image("Menu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }

                Spacer()
                
                Button {
                    
                } label: {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                }
            }
            .overlay {
                Text(attributedTitle)
                    .font(.title)
            }
            
            Text("Select Your Pizza".uppercased())
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top,15)
            
            // MARK: Custom Slider
            AnimatedSlider()
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(content: {
            Rectangle()
                .fill(Color("BG").gradient)
                .ignoresSafeArea()
        })
    }
    
    // MARK: Attributed Title
    var attributedTitle: AttributedString{
        var string = AttributedString(stringLiteral: "EATPIZZA")
        if let range = string.range(of: "PIZZA"){
            string[range].font = .system(.title, weight: .bold)
        }
        return string
    }
    
    // MARK: Animated Custom Slider
    @ViewBuilder
    func AnimatedSlider()->some View{
        GeometryReader{proxy in
            let size = proxy.size
            // MARK: Lazy Stack For Less Memory Usage
            LazyHStack(spacing: 0){
                ForEach(pizzas){pizza in
                    let index = getIndex(pizza: pizza)
                    let mainIndex = getIndex(pizza: selectedPizza)
                    VStack(spacing: 10){
                        Text(pizza.pizzaTitle)
                            .font(.largeTitle.bold())
                        
                        Text(pizza.pizzaDescription)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal)
                            .padding(.top,10)
                    }
                    .frame(width: size.width, height: size.height, alignment: .top)
                    // MARK: Changing View Based On Swipe
                    .rotationEffect(.init(degrees: mainIndex == index ? 0 : (index > mainIndex ? 180 : -180)))
                    .offset(x: -CGFloat(mainIndex) * size.width, y: index == mainIndex ? 0 : 40)
                }
            }
            
            // MARK: Pizza View
            // We're Showing Only the Current Pizza
            // Thus it will Reduce Memory Usage by not showing All the List of Pizzas
            PizzaView()
                .padding(.top,120)
        }
        .padding(.horizontal,-15)
        .padding(.top,35)
    }
    
    // MARK: PizzaView
    @ViewBuilder
    func PizzaView()->some View{
        GeometryReader{proxy in
            let size = proxy.size
            
            ZStack(alignment: .top) {
                Image(selectedPizza.pizzaImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    // MARK: Background Powder View
                    .background(alignment: .top, content: {
                        Image("Powder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width)
                            .offset(y: -30)
                    })
                    .scaleEffect(1.05,anchor: .top)
                
                ZStack(alignment: .top) {
                    // Hiding If It's First Slide
                    if pizzas.first?.id != selectedPizza.id{
                        // MARK: Left Side
                        ArcShape()
                            .trim(from: 0.05, to: 0.3)
                            .stroke(Color.gray, lineWidth: 1)
                            .offset(y: 75)
                        // MARK: Arrow Image
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: -30))
                            .offset(x: -(size.width / 2) + 30,y: 55)
                    }
                    
                    // Hiding If It's Last One
                    if pizzas.last?.id != selectedPizza.id{
                        // MARK: Right Side
                        ArcShape()
                            .trim(from: 0.7, to: 0.95)
                            .stroke(Color.gray, lineWidth: 1)
                            .offset(y: 75)
                        // MARK: Arrow Image
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: 30))
                            .offset(x: (size.width / 2) - 30,y: 55)
                    }
                    
                    // MARK: Price Attributed String
                    Text(priceAttributedString(value: selectedPizza.pizzaPrice))
                        .font(.largeTitle.bold())
                }
                .offset(y: -80)
            }
            // Rotation Will be Based on Direction
            .rotationEffect(.init(degrees: animatePizza ? (swipeDirection == .leading ? -360 : 360) : 0))
            .offset(y: size.height / 2)
            // MARK: Adding Gestures
            .gesture(
                DragGesture()
                    .onEnded{value in
                        let translation = value.translation.width
                        let index = getIndex(pizza: selectedPizza)
                        
                        if animatePizza{return}
                        
                        // MARK: If For Left Swipe
                        if translation < 0 && -translation > 50 && index != (pizzas.count - 1){
                            swipeDirection = .leading
                            handleSwipe()
                        }
                        
                        // MARK: If For Right Swipe
                        if translation > 0 && translation > 50 && index > 0{
                            swipeDirection = .trailing
                            handleSwipe()
                        }
                    }
            )
            
            HStack{
                ForEach(["SMALL","MEDIUM","LARGE"],id: \.self){text in
                    Text(text)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(pizzaSize == text ? Color("Orange") : .white)
                        .padding(.vertical,20)
                        .overlay(alignment: .bottom, content: {
                            if pizzaSize == text{
                                Circle()
                                    .fill(Color("Orange"))
                                    .frame(width: 7, height: 7)
                                    .offset(y: 3)
                                    .matchedGeometryEffect(id: "SIZETAB", in: animation)
                            }
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation{
                                pizzaSize = text
                            }
                        }
                }
            }
            .padding(.horizontal)
            .background {
                ZStack(alignment: .top) {
                    Rectangle()
                        .trim(from: 0.25, to: 1)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                    
                    Rectangle()
                        .trim(from: 0, to: 0.17)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                    
                    Text("SIZE")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .offset(y: -7)
                }
            }
            .padding(.horizontal,20)
            .padding(.top,10)
        }
        .padding(.top)
    }
    
    // MARK: Handle Swipe
    func handleSwipe(){
        let index = getIndex(pizza: selectedPizza)
        if swipeDirection == .leading{
            //print("Left")
            withAnimation(.easeInOut(duration: 0.85)){
                selectedPizza = pizzas[index + 1]
                animatePizza = true
            }
        }
        if swipeDirection == .trailing{
            //print("Right")
            withAnimation(.easeInOut(duration: 0.85)){
                selectedPizza = pizzas[index - 1]
                animatePizza = true
            }
        }
        
        // MARK: Restoring It After Animation has Finished its Job
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
            animatePizza = false
        }
    }
    
    // MARK: Pizza Index
    func getIndex(pizza: Pizza)->Int{
        return pizzas.firstIndex { CPizza in
            CPizza.id == pizza.id
        } ?? 0
    }
    
    // MARK: Price String
    func priceAttributedString(value: String)->AttributedString{
        var attrString = AttributedString(stringLiteral: value)
        if let range = attrString.range(of: "$"){
            attrString[range].font = .system(.callout, weight: .bold)
        }
        return attrString
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
