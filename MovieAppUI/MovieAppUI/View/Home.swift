//
//  Home.swift
//  MovieAppUI
//
//  Created by Balaji on 08/08/22.
//

import SwiftUI

struct Home: View {
    // MARK: View Properties
    @State var currentTab: Tab = .home
    @Namespace var animation
    
    // MARK: Carousel Properties
    @State var currentIndex: Int = 0
    var body: some View {
        VStack(spacing: 15){
            HeaderView()
            
            SearchBar()
            
            (Text("Featured")
                .fontWeight(.semibold) +
             Text(" Movies")
            )
            .font(.title2)
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,15)
            
            // MARK: Custom Carousel
            CustomCarousel(index: $currentIndex, items: movies, cardPadding: 150, id: \.id) { movie,cardSize in
                // MARK: YOUR CUSTOM CELL VIEW
                Image(movie.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(.horizontal,-15)
            .padding(.vertical)
            
            TabBar()
        }
        .padding([.horizontal,.top],15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            GeometryReader{proxy in
                let size = proxy.size
                
                TabView(selection: $currentIndex) {
                    ForEach(movies.indices,id: \.self){index in
                        Image(movies[index].artwork)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipped()
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentIndex)
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                LinearGradient(colors: [
                    .clear,
                    Color("BGTop"),
                    Color("BGBottom")
                ], startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: Custom Tab Bar
    @ViewBuilder
    func TabBar()->some View{
        HStack(spacing: 0){
            ForEach(Tab.allCases,id: \.rawValue){tab in
                VStack(spacing: -2){
                    Image(tab.rawValue)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.6))
                    
                    if currentTab == tab{
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut){currentTab = tab}
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom,10)
    }
    
    // MARK: Search Bar
    @ViewBuilder
    func SearchBar()->some View{
        HStack(spacing: 15){
            Image("Search")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .foregroundColor(.gray)
            
            TextField("Search",text: .constant(""))
                .padding(.vertical,10)
            
            Image("Mic")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical,6)
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white.opacity(0.12))
        }
        .padding(.top,20)
    }
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView()->some View{
        HStack{
            VStack(alignment: .leading, spacing: 6) {
                (Text("Hello")
                    .fontWeight(.semibold) +
                 Text(" iJustine")
                )
                .font(.title2)
                
                Text("Book your favourite movie")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            Button {
                
            } label: {
                Image("Justine")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
