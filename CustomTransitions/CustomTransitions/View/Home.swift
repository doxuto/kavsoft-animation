//
//  Home.swift
//  CustomTransitions
//
//  Created by Balaji on 09/07/22.
//

import SwiftUI

// MARK: This Project Targets iOS 15+
struct Home: View {
    // MARK: Sample Messages
    @State var chat: [Message] = [
        Message(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
        Message(message: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",isReply: true)
    ]
    // MARK: Properties
    @State var showHighlight: Bool = false
    @State var highlightChat: Message?
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 12){
                    ForEach(chat) { chat in
                        VStack(alignment: chat.isReply ? .leading : .trailing){
                            if chat.isEmojiAdded{
                                AnimatedEmoji(emoji: chat.emojiValue, color: chat.isReply ? .blue : Color("Gray"))
                                    .offset(x: chat.isReply ? -15 : 15)
                                    .padding(.bottom,-25)
                                    .zIndex(1)
                                    .opacity(showHighlight ? 0 : 1)
                            }
                            
                            ChatView(message: chat)
                                .zIndex(0)
                                // MARK: Using Anchor Preference To Read View's Anchor Values(Bounds)
                                .anchorPreference(key: BoundsPreference.self, value: .bounds, transform: { anchor in
                                    return [chat.id: anchor]
                                })
                        }
                        .padding(chat.isReply ? .leading : .trailing,60)
                        .onLongPressGesture {
                            withAnimation(.easeInOut){
                                showHighlight = true
                                highlightChat = chat
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom,800)
            }
            .navigationTitle("Transitions")
        }
        .overlay(content: {
            if showHighlight{
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation{
                            showHighlight = false
                            highlightChat = nil
                        }
                    }
            }
        })
        // MARK: Highlighting the View based on the Bounds Value and with OverlyaPreference
        .overlayPreferenceValue(BoundsPreference.self) { values in
            // MARK: Checking Which View is Tapped
            if let highlightChat,let preference = values.first(where: { item in
                item.key == highlightChat.id
            }){
                // To Retreive CGRect From Anchor We Need Geometry Proxy
                GeometryReader{proxy in
                    let rect = proxy[preference.value]
                    // MARK: Now Presenting View as an Overlay View
                    // So that it will Look like Custom Context Menu
                    ChatView(message: highlightChat,showLike: true)
                        // MARK: While Disappear it will not animate
                        // WorkAround: Add ID to View
                        .id(highlightChat.id)
                        .frame(width: rect.width, height: rect.height)
                        .offset(x: rect.minX, y: rect.minY < 0 ? 0 : rect.minY)
                }
                .transition(.asymmetric(insertion: .identity, removal: .offset(x: 1)))
            }
        }
    }
    
    // MARK: ChatView
    @ViewBuilder
    func ChatView(message: Message,showLike: Bool = false)->some View{
        ZStack(alignment: .bottomLeading) {
            Text(message.message)
                .padding(15)
                .background(message.isReply ? Color("Gray") : Color.blue)
                .foregroundColor(message.isReply ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            
            if showLike{
                EmojiView(hideView: $showHighlight,chat: message) { emoji in
                    // MARK: Closing Highliht
                    withAnimation(.easeInOut){
                        showHighlight = false
                        highlightChat = nil
                    }
                    // MARK: Finding Index
                    if let index = chat.firstIndex(where: { chat in
                        chat.id == message.id
                    }){
                        // MARK: Updating Values
                        withAnimation(.easeInOut.delay(0.3)){
                            chat[index].emojiValue = emoji
                            chat[index].isEmojiAdded = true
                        }
                    }
                }
                .offset(y: 55)
            }
        }
    }
}

// MARK: Animated Emoji View
struct AnimatedEmoji: View{
    var emoji: String
    var color: Color = .blue
    // MARK: Animation Properties
    @State var animationValues: [Bool] = Array(repeating: false, count: 6)
    var body: some View{
        ZStack{
            Text(emoji)
                .font(.system(size: 25))
                .padding(7)
                .background {
                    Circle()
                        .fill(color)
                }
                .scaleEffect(animationValues[2] ? 1 : 0.01)
                .overlay {
                    Circle()
                        .stroke(color,lineWidth: animationValues[1] ? 0 : 100)
                        .clipShape(Circle())
                        .scaleEffect(animationValues[0] ? 1.6 : 0.01)
                }
                // MARK: Random Circles
                .overlay {
                    ZStack{
                        ForEach(1...20,id: \.self){index in
                            Circle()
                                .fill(color)
                                .frame(width: .random(in: 3...5), height: .random(in: 3...5))
                                .offset(x: .random(in: -5...5), y: .random(in: -5...5))
                                .offset(x: animationValues[3] ? 45 : 10)
                                .rotationEffect(.init(degrees: Double(index) * 18.0))
                                .scaleEffect(animationValues[2] ? 1 : 0.01)
                                .opacity(animationValues[4] ? 0 : 1)
                        }
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                withAnimation(.easeInOut(duration: 0.35)){
                    animationValues[0] = true
                }
                withAnimation(.easeInOut(duration: 0.45).delay(0.06)){
                    animationValues[1] = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.3)){
                    animationValues[2] = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.4)){
                    animationValues[3] = true
                }
                withAnimation(.easeInOut(duration: 0.55).delay(0.55)){
                    animationValues[4] = true
                }
            }
        }
    }
}

// MARK: Animated Emoji Like System
struct EmojiView: View{
    @Binding var hideView: Bool
    var chat: Message
    // MARK: Returns The Tapped Emoji
    var onTap: (String)->()
    // MARK: Sample Emoji's
    var emojis: [String] = ["🥳","❤️","🥲"]
    // MARK: Animation Properties
    // Update the Count based on your Emoji Array Size
    @State var animateEmoji: [Bool] = Array(repeating: false, count: 3)
    @State var animateView: Bool = false
    var body: some View{
        HStack(spacing: 12){
            ForEach(emojis.indices,id: \.self){index in
                Text(emojis[index])
                    .font(.system(size: 25))
                    .scaleEffect(animateEmoji[index] ? 1 : 0.01)
                    .onAppear {
                        // MARK: Animating Emoji's With Delay Based on Index
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            withAnimation(.easeInOut.delay(Double(index) * 0.1)){
                                animateEmoji[index] = true
                            }
                        }
                    }
                    .onTapGesture {
                        onTap(emojis[index])
                    }
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical,8)
        .background {
            Capsule()
                .fill(.white)
                .mask {
                    Capsule()
                        .scaleEffect(animateView ? 1 : 0,anchor: .leading)
                }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)){
                animateView = true
            }
        }
        .onChange(of: hideView) { newValue in
            if !newValue{
                withAnimation(.easeInOut(duration: 0.2).delay(0.15)){
                    animateView = false
                }
                
                for index in emojis.indices{
                    withAnimation(.easeInOut){
                        animateEmoji[index] = false
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
