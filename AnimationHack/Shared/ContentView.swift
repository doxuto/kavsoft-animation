//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 26/05/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Properties
    @State var showDetail: Bool = false
    // MARK: Other Detail Content Visibilty
    @State var showDetailContent: Bool = false
    // MARK: Namespace
    @Namespace var animation
    var body: some View {
        NavigationView{
            VStack(spacing: 15){
                CardView(imageName: "Card1")
                if !showDetail{
                    CardView(imageName: "Card2")
                        .matchedGeometryEffect(id: "CARD", in: animation)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 4)){
                                showDetail = true
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("SwiftUI Hack")
        }
        .overlay(alignment: .top) {
            if showDetail{
                VStack(spacing: 15){
                    CardView(imageName: "Card2")
                        .matchedGeometryEffect(id: "CARD", in: animation)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 4)){
                                showDetailContent = false
                            }
                            withAnimation(.easeInOut(duration: 4).delay(0.05)){
                                showDetail = false
                            }
                        }
                    
                    VStack{
                        // MARK: Your Detail Content Goes Here
                    }
                    .opacity(showDetailContent ? 1 : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
                .background(Color.white.opacity(showDetailContent ? 1 : 0))
                // MARK: Hack
                // MARK: Use Transition
                // Avoid Identity & Offset With Zero
                .transition(.offset(x: 1, y: 1))
                .onAppear {
                    withAnimation(.easeInOut(duration: 4)){
                        showDetailContent = true
                    }
                }
            }
        }
    }
    
    // MARK: Card View
    @ViewBuilder
    func CardView(imageName: String)->some View{
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
