//
//  Home.swift
//  PizzaChallenge (iOS)
//
//  Created by Balaji on 11/12/21.
//

import SwiftUI
import SceneKit

struct Home: View {
    // MARK: Sample Pizza Types
    @State var pizzas: [Pizza] = [
        Pizza(breadName: "Bread_1"),
        Pizza(breadName: "Bread_2"),
        Pizza(breadName: "Bread_3"),
        Pizza(breadName: "Bread_4"),
        Pizza(breadName: "Bread_5"),
    ]
    // MARK: Pizza Animation Properties
    @State var currentPizza: String = "Bread_1"
    @State var currentSize: PizzaSize = .medium
    @Namespace var animation
    // MARK: Sample Pizza Toppings
    let toppings: [String] = ["Basil","Onion","Broccoli","Mushroom","Sausage"]
    // MARK: Pizza Box Animation Properties
    @State var pizzaTop: SCNScene? = .init(named: "Pizza_Box.scn")
    @State var pizzaBottom: SCNScene? = .init(named: "Pizza_Box.scn")
    @State var movePlate: Bool = false
    @State var showBox: Bool = false
    @State var shirinkPizza: Bool = false
    @State var addItemToCart: Bool = false
    @State var cartItems: [Pizza] = []
    // To Avoid Animation Interruption
    @State var disableControls: Bool = false
    var body: some View {
        VStack{
            NavBar()
            
            // MARK: Pizza View
            GeometryReader{proxy in
                let size = proxy.size
                ZStack{
                    Image("Plate")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal,30)
                        .padding(.vertical)
                        .offset(x: movePlate ? 500 : 0)
                        .opacity(showBox ? 0 : 1)
                    
                    ZStack{
                        CustomSceneKitView(scene: $pizzaBottom)
                            .frame(width: size.width, height: size.height)
                            .rotationEffect(.init(degrees: 180))
                            .scaleEffect(showBox ? 1.1 : 0.9)
                            .opacity(showBox ? 1 : 0)
                        
                        // MARK: Pizza View With Paging
                        TabView(selection: $currentPizza) {
                            ForEach(pizzas){pizza in
                                ZStack{
                                    Image(pizza.breadName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(40)
                                    
                                    ToppingsView(toppings: pizza.toppings, pizza: pizza,width: (size.width / 2) - 45)
                                }
                                .scaleEffect(currentSize == .large ? 1 : (currentSize == .medium ? 0.95 : 0.9))
                                .tag(pizza.breadName)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .scaleEffect(movePlate ? 0.7 : 1)
                        .scaleEffect(shirinkPizza ? 0.8 : 1,anchor: .top)
                        // MARK: Rotating And Adjusting to Fit Into Box
                        .rotation3DEffect(.init(degrees: showBox ? -40 : 0), axis: (x: 1, y: 0, z: 0), anchorZ: showBox ? 120 : 0)
                        .offset(y: showBox ? 120 : 0)
                        
                        CustomSceneKitView(scene: $pizzaTop,isTopPortion: true)
                            .frame(width: size.width, height: size.height)
                            // Simply Rotating To It's Correct Form
                            .rotationEffect(.init(degrees: 180))
                            .scaleEffect(showBox ? 1.1 : 0.9)
                            .opacity(showBox ? 1 : 0)
                    }
                    .scaleEffect(addItemToCart ? 0.01 : 1, anchor: .topTrailing)
                    .offset(x: addItemToCart ? -30 : 0, y: addItemToCart ? -35 : 0)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 300)
            
            ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : .init(), showsIndicators: false) {
                VStack{
                    Text("$17")
                        .font(.title.bold())
                        .foregroundColor(.black)
                        .padding(.top,10)
                    
                    PizzaSizePicker()
                    
                    CustomToppings()
                    
                    Button(action: addToCart){
                        HStack(spacing: 15){
                            Image(systemName: "cart.fill")
                                .font(.title2)
                            
                            Text("Add to cart")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical,12)
                        .padding(.horizontal,30)
                        .background(Color("Brown"),in: RoundedRectangle(cornerRadius: 15))
                    }
                    .frame(maxHeight: .infinity,alignment: .center)
                }
            }
        }
        .disabled(disableControls)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
    }
    
    // MARK: Adding Pizza To Cart
    func addToCart(){
        disableControls = true
        withAnimation(.easeInOut(duration: 0.6)){
            movePlate = true
        }
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(0.4)){
            showBox = true
        }
        
        // MARK: Closing Box
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65){
            withAnimation(.easeInOut){
                shirinkPizza = true
            }
            
            // MARK: This Will Animates Changes in SCNFILE
            SCNTransaction.animationDuration = 0.6
            // MARK: Adjusting X And Y Axis
            pizzaTop?.rootNode.childNode(withName: "Cover", recursively: true)?.position.y = 33
            pizzaTop?.rootNode.childNode(withName: "Cover", recursively: true)?.position.z = 108
            pizzaTop?.rootNode.childNode(withName: "Cover", recursively: true)?.eulerAngles.x = 0
            pizzaBottom?.rootNode.childNode(withName: "Closed_Box", recursively: true)?.eulerAngles.x = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                withAnimation(.easeInOut(duration: 0.6)){
                    addItemToCart = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                    // MARK: Adding Item to Cart and Resetting Animation
                    cartItems.append(pizzas[getIndex(breadName: currentPizza)])
                    clearAnimation()
                }
            }
        }
    }
    
    // MARK: Clearing All Pizza Box Animation
    func clearAnimation(){
        shirinkPizza = false
        showBox = false
        withAnimation{
            movePlate = false
        }
        addItemToCart = false
        
        // MARK: Resetting SCN Files
        pizzaTop = .init(named: "Pizza_Box.scn")
        pizzaBottom = .init(named: "Pizza_Box.scn")
        
        pizzas[getIndex(breadName: currentPizza)].toppings.removeAll()
        disableControls = false
    }
    
    @ViewBuilder
    func PizzaSizePicker()->some View{
        HStack(spacing: 20){
            ForEach(PizzaSize.allCases,id: \.rawValue){size in
                Button {
                    withAnimation{
                        currentSize = size
                    }
                } label: {
                    Text(size.rawValue)
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            ZStack{
                                if currentSize == size{
                                    Color.white
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                                        .shadow(color: Color.black.opacity(0.03), radius: 5, x: -5, y: -5)
                                        .matchedGeometryEffect(id: "SIZEINDICATOR", in: animation)
                                }
                            }
                        )
                }

            }
        }
        .padding(.top,10)
    }
    
    // MARK: Nav Bar
    @ViewBuilder
    func NavBar()->some View{
        HStack{
            Button {
                
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "cart")
                    .font(.title2)
                    .foregroundColor(.black)
                    .overlay(alignment: .topTrailing) {
                        Text("\(cartItems.count)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(5)
                            .background(content: {
                                Circle()
                                    .fill(.red)
                            })
                            .foregroundColor(.white)
                            .offset(x: 6, y: -14)
                            .opacity(cartItems.isEmpty ? 0 : 1)
                    }
            }
        }
        .overlay(
            Text("Pizza")
                .font(.title2.bold())
                .foregroundColor(.black)
        )
        .padding(15)
    }
    
    // MARK: Custom Toppings View
    @ViewBuilder
    func CustomToppings()->some View{
        Group{
            Text("CUSTOMIZE YOUR PIZZA")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.top,25)
                .padding(.leading)
            
            ScrollViewReader{proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -10){
                        ForEach(toppings,id: \.self){topping in
                            // Displaying Topping Images
                            // There Are Total 10 Toppings Images Available For Each Topping
                            Image("\(topping)_3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(12)
                                .background{
                                    Color.green
                                        .clipShape(Circle())
                                        .opacity(isAdded(topping: topping) ? 0.15 : 0)
                                        .animation(.easeInOut, value: currentPizza)
                                }
                                .padding()
                                .contentShape(Circle())
                                .onTapGesture {
                                    // MARK: Adding/Removing Toppings
                                    if isAdded(topping: topping){
                                        if let index = pizzas[getIndex(breadName: currentPizza)].toppings.firstIndex(where: { currentTopping in
                                            return topping == currentTopping.toppingName
                                        }){
                                            pizzas[getIndex(breadName: currentPizza)].toppings.remove(at: index)
                                        }
                                        
                                        return
                                    }
                                    
                                    // MARK: Creating Some Random Positions
                                    var positions: [CGSize] = []
                                    
                                    for _ in 1...20{
                                        positions.append(.init(width: .random(in: -20...60), height: .random(in: -45...45)))
                                    }
                                    
                                    let toppingObject = Topping(toppingName: topping,randomToppingPostions: positions)
                                    withAnimation{
                                        pizzas[getIndex(breadName: currentPizza)].toppings.append(toppingObject)
                                    }
                                }
                                .tag(topping)
                        }
                    }
                }
                .onChange(of: currentPizza) { _ in
                    withAnimation{
                        proxy.scrollTo(toppings.first ?? "", anchor: .leading)
                    }
                }
            }
        }
    }
    
    // MARK: Checking If Topping is Already Added
    func isAdded(topping: String)->Bool{
        let status = pizzas[getIndex(breadName: currentPizza)].toppings.contains { currentTopping in
            return currentTopping.toppingName == topping
        }
        
        return status
    }
    
    // MARK: Finding Index
    func getIndex(breadName: String)->Int{
        let index = pizzas.firstIndex { pizza in
            return pizza.breadName == breadName
        } ?? 0
        
        return index
    }
    
    @ViewBuilder
    func ToppingsView(toppings: [Topping],pizza: Pizza,width: CGFloat)->some View{
        Group{
            ForEach(toppings.indices,id: \.self){index in
                // Each topping consists of 10 topping images....
                let topping = toppings[index]
                
                ZStack{
                    // Adding more Topping Images...
                    // with an illusion...
                    ForEach(1...20,id: \.self){subIndex in
                        // 360/10 = 36....
                        let rotation: Double = Double(subIndex) * 36
                        let crtIndex = (subIndex > 10 ? (subIndex - 10) : subIndex)
                        
                        Image("\(topping.toppingName)_\(crtIndex)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        // Since index starts from 0...
                            .offset(x: (width / 2) - topping.randomToppingPostions[subIndex - 1].width,y: topping.randomToppingPostions[subIndex - 1].height)
                            .rotationEffect(.init(degrees: rotation))
                        // Spreading Topping into random positions in 360 rotation...
                    }
                }
                // Adding Scaling Animation...
                // Triggering Scaling animation when the topping is added...
                .scaleEffect(topping.isAdded ? 1 : 10,anchor: .center)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        withAnimation{
                            pizzas[getIndex(breadName: pizza.breadName)].toppings[index].isAdded = true
                        }
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Pizza Size Enum
enum PizzaSize: String,CaseIterable{
    case small = "S"
    case medium = "M"
    case large = "L"
}
