//
//  Home.swift
//  Infinite Carousel
//
//  Created by Balaji on 27/03/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var currentPage: String = ""
    @State private var listOfPages: [Page] = []
    /// Infinite Carousel Properties
    @State private var fakedPages: [Page] = []
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            if currentPage != "" {
                TabView(selection: $currentPage, content: {
                    ForEach(fakedPages) { Page in
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Page.color.gradient)
                            .frame(width: 300, height: size.height)
                            .tag(Page.id.uuidString)
                            /// Calculating Entire Page Scroll Offset
                            .offsetX(currentPage == Page.id.uuidString) { rect in
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(fakeIndex(Page)))
                                /// Converting Page Offset into Progress
                                let pageProgress = pageOffset / size.width
                                /// Infinite Carousel Logic
                                if -pageProgress < 1.0 {
                                    /// Moving to the Last Page
                                    /// Which is Actually the First Duplicated Page
                                    /// Safe Check
                                    if fakedPages.indices.contains(fakedPages.count - 1) {
                                        currentPage = fakedPages[fakedPages.count - 1].id.uuidString
                                    }
                                }
                                
                                if -pageProgress > CGFloat(fakedPages.count - 1) {
                                    /// Moving to the First Page
                                    /// Which is Actually the Last Duplicated Page
                                    /// Safe Check
                                    if fakedPages.indices.contains(1) {
                                        currentPage = fakedPages[1].id.uuidString
                                    }
                                }
                            }
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(alignment: .bottom) {
                    PageControl(totalPages: listOfPages.count, currentPage: originalIndex(currentPage))
                        .offset(y: -15)
                }
            }
        }
        .frame(height: 400)
        .onAppear {
            guard fakedPages.isEmpty else { return }
            /// Creating Some Sample Tab's
            for color in [Color.red, Color.blue, Color.yellow, Color.primary, Color.brown] {
                listOfPages.append(.init(color: color))
            }
            createCarousel(true)
        }
    }
    
    /// Creating Infinite Carousel
    /// Call this Method When ever the Page data is Updated
    func createCarousel(_ setFirstPageAsCurrentPage: Bool = false) {
        fakedPages.removeAll()
        fakedPages.append(contentsOf: listOfPages)
        
        if var firstPage = listOfPages.first, var lastPage = listOfPages.last {
            if setFirstPageAsCurrentPage {
                currentPage = firstPage.id.uuidString
            }
            
            /// Updating ID
            firstPage.id = .init()
            lastPage.id = .init()
            
            fakedPages.append(firstPage)
            fakedPages.insert(lastPage, at: 0)
        }
    }
    
    func fakeIndex(_ of: Page) -> Int {
        return fakedPages.firstIndex(of: of) ?? 0
    }
    
    func originalIndex(_ id: String) -> Int {
        return listOfPages.firstIndex { page in
            page.id.uuidString == id
        } ?? 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
