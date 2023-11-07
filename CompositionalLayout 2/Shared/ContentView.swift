//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 23/04/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject var imageFetcher: ImageFetcher = .init()
    var body: some View {
        NavigationView{
            Group{
                // MARK: Custom View
                if let images = imageFetcher.fetchedImages{
                    ScrollView{
                        CompositionalView(items: 1...30, id: \.self) { item in
                            ZStack{
                                Rectangle()
                                    .fill(.cyan)
                                
                                Text("\(item)")
                                    .font(.title.bold())
                            }
                        }
                        .padding()
                        .padding(.bottom,10)
                        
                        if imageFetcher.startPagination && !imageFetcher.endPagination{
                            ProgressView()
                                .offset(y: -15)
                                .onAppear {
                                    // MARK: Slight Delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        imageFetcher.updateImages()
                                    }
                                }
                        }
                    }
                }else{
                    ProgressView()
                }
            }
            .navigationTitle("Compositional Layout")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
