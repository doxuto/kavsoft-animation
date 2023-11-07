//
//  Home.swift
//  ScrollIndicator
//
//  Created by Balaji on 18/10/22.
//

import SwiftUI

struct Home: View {
    // MARK: View Properties
    @State var characters: [Character] = []
    @State var scrollerHeight: CGFloat = 0
    @State var indicatorOffset: CGFloat = 0
    // MARK: View's Start Offset After The Navigation Bar
    @State var startOffset: CGFloat = 0
    @State var hideIndicatorLabel: Bool = true
    
    // MARK: ScrollView EndDeclaration Properties
    // Your Own Timing
    @State var timeOut: CGFloat = 0.3
    
    @State var currentCharacter: Character = .init(value: "")
    var body: some View {
        NavigationView{
            GeometryReader{
                let size = $0.size
                
                ScrollViewReader(content: { proxy in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 0){
                            // MARK: Sample Contacts View
                            ForEach(characters){character in
                                ContactsForCharacter(character: character)
                                    .id(character.index)
                            }
                        }
                        .padding(.top,15)
                        .padding(.trailing,20)
                        .offset { rect in
                            // MARK: When Ever Scrolling Does
                            // Resetting Timeout
                            if hideIndicatorLabel && rect.minY < 0{
                                timeOut = 0
                                hideIndicatorLabel = false
                            }
                            
                            // MARK: Finding Scroll Indicator height
                            let rectHeight = rect.height
                            let viewHeight = size.height + (startOffset / 2)
                            
                            let scrollerHeight = (viewHeight / rectHeight) * viewHeight
                            self.scrollerHeight = scrollerHeight
                            
                            // MARK: Finding Scroll Indicator Offset
                            let progress = rect.minY / (rectHeight - size.height)
                            // MARK: Simply Multiply With View Height
                            // Eliminating Scroller Height
                            self.indicatorOffset = -progress * (size.height - scrollerHeight)
                        }
                    }
                })
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .overlay(alignment: .topTrailing, content: {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 2, height: scrollerHeight)
                        .overlay(alignment: .trailing, content: {
                            // MARK: Bubble Image
                            Image(systemName: "bubble.middle.bottom.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 45, height: 45)
                                .rotationEffect(.init(degrees: -90))
                                .overlay(content: {
                                    Text(currentCharacter.value)
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        .offset(x: -3)
                                })
                                .environment(\.colorScheme, .dark)
                                .offset(x: hideIndicatorLabel || currentCharacter.value == "" ? 65 : 0)
                                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6), value: hideIndicatorLabel || currentCharacter.value == "")
                        })
                        .padding(.trailing,5)
                        .offset(y: indicatorOffset)
                })
                .coordinateSpace(name: "SCROLLER")
            }
            .navigationTitle("Contact's")
            .offset { rect in
                if startOffset != rect.minY{
                    startOffset = rect.minY
                }
            }
        }
        .onAppear {
            characters = fetchCharacters()
        }
        // MARK: I'm Going to Implement a Custom ScrollView End Declaration with the help of the Timer And Offset Values
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()) { _ in
            if timeOut < 0.3{
                timeOut += 0.01
            }else{
                // MARK: Scrolling is Finished
                // It Will Fire Many Times So Use Some Conditions Here
                if !hideIndicatorLabel{
                    print("SCrolling is Finished")
                    hideIndicatorLabel = true
                }
            }
        }
    }
    
    // MARK: Contact Row For Each Alphabet
    @ViewBuilder
    func ContactsForCharacter(character: Character)->some View{
        VStack(alignment: .leading, spacing: 15) {
            Text(character.value)
                .font(.largeTitle.bold())
            
            ForEach(1...4,id: \.self){_ in
                HStack(spacing: 10){
                    Circle()
                        .fill(character.color)
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(character.color.opacity(0.6))
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(character.color.opacity(0.4))
                            .frame(height: 20)
                            .padding(.trailing,80)
                    }
                }
            }
        }
        .offset(completion: { rect in
            // MARK: Verifying Which section is at the Top (Near NavBar)
            // Updating Character Rect When ever it's Updated
            if characters.indices.contains(character.index){
                characters[character.index].rect = rect
            }
            
            // Since Every Character moves up and goes beyond Zero (It will be like A,B,C,D)
            // So We're taking the last character
            if let last = characters.last(where: { char in
                char.rect.minY < 0
            }),last.id != currentCharacter.id{
                currentCharacter = last
                print(currentCharacter.value)
            }
        })
        .padding(15)
    }
    
    // MARK: Fetching Characters
    func fetchCharacters()->[Character]{
        let alphabets: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var characters: [Character] = []
        
        characters = alphabets.compactMap({ character -> Character? in
            return Character(value: String(character))
        })
        
        // MARK: Sample Color's
        let colors: [Color] = [.red,.yellow,.pink,.orange,.cyan,.indigo,.purple,.blue]
        
        // MARK: Setting Index And Random Color
        for index in characters.indices{
            characters[index].index = index
            characters[index].color = colors.randomElement()!
        }
        
        return characters
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Offset Reader
extension View{
    @ViewBuilder
    func offset(completion: @escaping (CGRect)->())->some View{
        self
            .overlay {
                GeometryReader{
                    let rect = $0.frame(in: .named("SCROLLER"))
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}

// MARK: Offset Key
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
