//
//  Home.swift
//  AppleWalletScroll (iOS)
//
//  Created by Balaji on 17/02/22.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var offset: CGFloat = 0
    // To avoid divide by zero error
    @State var width: CGFloat = 1
    @State var height: CGFloat = UIScreen.main.bounds.height
    
    // To Hide the Wallet Cards when its scrolled over
    @State var cardOffset: [CGFloat] = [0,0,0,0]
    
    var body: some View {
        
        VStack(spacing: 0){
            
            NavBar()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                let leftValue: CGFloat = (2.3 / (width / (width - 390)))
                let value: CGFloat = 2.3 + (leftValue < -5 ? 0 : leftValue)
                let maxHeight: CGFloat = (height + (180 - 60) * (value + 1))
                
                VStack{
                    
                    Text("Wallet")
                        .font(.system(size: 65, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top,screenBounds().height / 4)
                    
                    // Wallet
                    Wallet{
                    
                        VStack(alignment: .leading,spacing: 15){
                            Text("Carry\none thing.\nEverything.")
                                .font(.system(size: 45, weight: .bold))
                                .padding(.leading,15)
                            
                            Text("The Wallet app lives right on your iPhone. It’s where you securely keep your credit and debit cards, driver’s license or state ID, transit cards, event tickets, keys, and more — all in one place. And it all works with iPhone or Apple Watch, so you can take less with you but always bring more.")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(height: 400, alignment: .top)
                                .padding(15)
                            
                            // Sample Cards
                            SampleCard(color: Color("Blue"))
                            
                            SampleCard(color: Color("Green"),index: 1)
                            
                            SampleCard(color: Color("Yellow"),index: 2)
                            
                            SampleCard(color: Color("Orange"),index: 3)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity)
                .mask{
                    Rectangle()
                        .padding(.horizontal,-offset > (maxHeight + (width < 390 ? 8 : 4)) ? 15 : 0)
                }
                .modifier(OffsetModifier(coordinateSpace: "SCROLL"){rect in
                    self.offset = (rect.minY < 0 ? rect.minY : 0)
                    if width == 1{
                        self.width = rect.width
                    }
                })
                .padding(.bottom,screenBounds().width)
            }
            .coordinateSpace(name: "SCROLL")
        }
        .background(Color("BG"))
    }
    
    @ViewBuilder
    func SampleCard(color: Color,index: Int = 0)->some View{
        GeometryReader{proxy in
            
            Text("Travel\nYour even more\nmobile device.")
                .font(.system(size: 38, weight: .bold))
                .padding(.top,50)
                .padding(.bottom,20)
                .padding(.horizontal,15)
                .frame(maxWidth: .infinity,alignment: .leading)
                .modifier(OffsetModifier(coordinateSpace: "SCROLL", rect: { rect in
                    cardOffset[index] = rect.minY
                }))
        }
        .frame(height: 250,alignment: .top)
        .background(color,in: RoundedRectangle(cornerRadius: 35))
        .padding(.horizontal,15)
    }
    
    @ViewBuilder
    func NavBar()->some View{
        
        // MARK: Top Nav Bar
        HStack{
            Button {
                
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title3)
            }

            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "bag")
                    .font(.title3)
            }
        }
        .overlay(content: {
            Image(systemName: "applelogo")
                .font(.title2)
        })
        .foregroundColor(.white)
        .padding()
        .background(Color("TopBar"))
    }
    
    // MARK: Wallet
    @ViewBuilder
    func Wallet<Content: View>(@ViewBuilder content: @escaping ()->Content)->some View{
        
        // MARK: Animation Changes
        // For iPhone 13 the max Scale value is 2.3
        // iPhone 13 Screen width is 390
        // Adopting this for all screen width
        let leftValue: CGFloat = (2.3 / (width / (width - 390)))
        let value: CGFloat = 2.3 + (leftValue < -5 ? 0 : leftValue)
        
        let scale: CGFloat = -(offset / 200) < value ? (offset / 200) : -(value + (width > 390 ? 0.1 : 0.001))
        // Moving Wallet down when it hits the Max Scale
        let scaledOffset: CGFloat = (offset + (200 * value))
        
        // Stopping before the Circle Starts
        // Why + 1 because default scale starts at 1
        let maxHeight: CGFloat = (height + (180 - 60) * (value + 1))
        let exhaustHeight: CGFloat = -(200 * value)
        
        // Rounded Rect Radius
        let radius: CGFloat = (-scale > value ? (-offset / 50) : 0)
        
        VStack{
            
            GeometryReader{proxy in
                
                ZStack{
                 
                    RoundedRectangle(cornerRadius: 35 + radius)
                        .offset(y: -scale > value ? -scaledOffset / 5 : 0)
                        .opacity(-offset > maxHeight ? 0 : 1)
                    
                    RoundedRectangle(cornerRadius: 15 + (radius / 2))
                        .fill(Color("BG"))
                        .padding(.horizontal,25)
                        .padding(.vertical,35)
                        .offset(y: -scale > value ? -scaledOffset / 10 : 0)
                    
                    ZStack{
                        
                        // Individual Cards
                        WalletCard(color: Color("Blue"), hPadding: 35, vPadding: 45)
                        WalletCard(color: Color("Green"), hPadding: 35, vPadding: 55,index: 1)
                        WalletCard(color: Color("Yellow"), hPadding: 35, vPadding: 65,index: 2)
                        WalletCard(color: Color("Orange"), hPadding: 35, vPadding: 75,index: 3)
                        
                        // Hiding Bottom Portion
                        Rectangle()
                            .fill(Color("BG"))
                            .padding(.horizontal,35)
                            .padding(.vertical,65)
                            .offset(y: 25)
                        
                        // Circle
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .fill(Color("Orange"))
                            .frame(width: 40, height: 40)
                            .offset(y: -0.5)
                    }
                }
                .onAppear {
                    // Eliminating MinY
                    self.height -= proxy.frame(in: .global).minY
                }
            }
            .frame(width: 190, height: 180)
            .scaleEffect(1 - scale)
            .offset(y: -offset)
            .offset(y: -offset < maxHeight ? (-scale > value ? -scaledOffset : 0) : maxHeight + exhaustHeight)
            .zIndex(100)
            
            // MARK: Bottom Content
            content()
                .padding(.top,maxHeight)
        }
    }
    
    @ViewBuilder
    func WalletCard(color: Color,hPadding: CGFloat,vPadding: CGFloat,index: Int = 0)->some View{
        GeometryReader{proxy in
            
            let minY = proxy.frame(in: .named("SCROLL")).minY - 20
            
            // Removing Horizontal Padding 15
            let width = proxy.frame(in: .named("SCROLL")).width
            let paddedWidth = width - 30
            let scale = paddedWidth / width
            
            let leftValue: CGFloat = (2.3 / (width / (width - 390)))
            let value: CGFloat = 2.3 + (leftValue < -5 ? 0 : leftValue)
            let maxHeight: CGFloat = (height + (180 - 60) * (value + 1))
            
            RoundedRectangle(cornerRadius: -offset > maxHeight ? 15 : 8)
                .fill(color)
                .opacity(cardOffset[index] < minY ? 0 : 1)
                .scaleEffect(x: -offset > maxHeight ? scale : 1)
        }
        .padding(.horizontal,hPadding)
        .padding(.vertical,vPadding)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Extensions
extension View{
    // MARK: Screen Size
    func screenBounds()->CGRect{
        return UIScreen.main.bounds
    }
}
