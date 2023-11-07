//
//  Home.swift
//  3D Carousel
//
//  Created by Balaji on 28/10/22.
//

import SwiftUI

struct Home: View {
    // MARK: Sample Cards
    @State var cards: [Card] = []
    var body: some View {
        VStack{
            Carousel3D(cardSize: CGSize(width: 150, height: 220), items: cards, id: \.id, content: { card in
                CardView(card: card)
            })
            .padding(.bottom,100)
            
            HStack{
                Button {
                    // MARK: Adding Next Card
                    if cards.count != 6{
                        cards.append(.init(imageFile: "Pic\(cards.count + 1)"))
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                
                Button {
                    // MARK: Deleting Last Card
                    if !cards.isEmpty{
                        cards.removeLast()
                    }
                } label: {
                    Label("Delete", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .onAppear {
            for index in 1...6{
                cards.append(.init(imageFile: "Pic\(index)"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Card View
// NOTE: IF YOU NEED STATE UPDATES THEN CREATE VIEWS WITH SEPARATE STRUCTS
// LIKE THE BELOW CARDVIEW
struct CardView: View{
    var card: Card
    
    var body: some View{
        ZStack{
            Image(card.imageFile)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        // MARK: Use the Exact Same Size
        .frame(width: 150, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
