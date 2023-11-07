//
//  InfiniteCarousel.swift
//  tvOSInfiniteCarousel
//
//  Created by Balaji on 19/04/23.
//

import SwiftUI

struct InfiniteCarousel: View {
    @State private var currentIndex: Int = 0
    @State private var listOfPages: [Page] = []
    /// Infinite Carousel Properties
    @State private var fakedPages: [Page] = []
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach($fakedPages) { $link in
                            CardView(link: $link, size: size)
                        }
                    }
                    .background(FindScrollView(size: size, currentIndex: $currentIndex, totalCount: fakedPages.count) { isFirst in
                        if isFirst {
                            if fakedPages.indices.contains(1) {
                                fakedPages[1].isFocused = true
                            }
                        } else {
                            if fakedPages.indices.contains(fakedPages.count - 2) {
                                fakedPages[fakedPages.count - 2].isFocused = true
                            }
                        }
                    })
                }
            }
            .frame(height: 400)
            
            PageControl(totalPages: listOfPages.count, currentPage: currentIndex)
        }
        .onAppear {
            guard fakedPages.isEmpty else { return }
            /// Creating Some Sample Tab's
            for color in [Color.red, Color.blue, Color.yellow, Color.primary, Color.brown] {
                listOfPages.append(.init(color: color))
            }
            createCarousel()
        }
    }
    
    func fakeIndex(_ of: Page) -> Int {
        return fakedPages.firstIndex(of: of) ?? 0
    }
    
    /// Creating Infinite Carousel
    /// Call this Method When ever the Page data is Updated
    func createCarousel() {
        fakedPages.removeAll()
        fakedPages.append(contentsOf: listOfPages)
        
        if var firstPage = listOfPages.first, var lastPage = listOfPages.last {
            /// Updating ID
            firstPage.id = .init()
            lastPage.id = .init()
            
            fakedPages.append(firstPage)
            fakedPages.insert(lastPage, at: 0)
        }
    }
}
