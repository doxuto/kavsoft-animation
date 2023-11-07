//
//  Home.swift
//  AnimationChallenge4
//
//  Created by Balaji on 14/06/22.
//

import SwiftUI

struct Home: View {
    // MARK: Albums
    @State var albums: [Album] = sampleAlbums
    // MARK: Custom Scroller Properties
    @State var currentIndex: Int = 0
    @State var currentAlbum: Album = sampleAlbums.first!
    var body: some View {
        VStack(spacing: 0){
            Text(titleString)
                .font(.largeTitle)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.bottom,40)
            
            // MARK: Custom Scroller
            VStack{
                AlbumArtworkScroller()
                    .zIndex(1)
                standView
                    .zIndex(0)
            }
            .padding(.horizontal,-15)
            .zIndex(1)
            
            // MARK: Page TabView
            TabView{
                ForEach($albums) { $album in
                    AlbumCardView(album: album)
                        .offsetX { value,width in
                            if currentIndex == getIndex(album: album){
                                // MARK: Updating Offset
                                // Converting Offset to 80
                                // Disk Will Goes Inside When Doing Swipe on Both Sides
                                var offset = ((value > 0 ? -value : value) / width) * 80
                                offset = (-offset < 80 ? offset : -80)
                                album.diskOffset = offset
                            }
                            
                            // MARK: Updating Card When The Card is Released
                            if value == 0 && currentIndex != getIndex(album: album){
                                album.diskOffset = 0
                                withAnimation(.easeInOut(duration: 0.6)){
                                    albums[currentIndex].showDisk = false
                                    currentIndex = getIndex(album: album)
                                    currentAlbum = albums[currentIndex]
                                }
                                
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1).delay(0.1)){
                                    albums[currentIndex].showDisk = true
                                }
                            }
                        }
                }
            }
            .padding(.horizontal,-15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .zIndex(0)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BG"), ignoresSafeAreaEdges: .all)
        .onAppear {
            // Showing Disk For First Card
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1).delay(0.4)){
                albums[currentIndex].showDisk = true
            }
        }
    }
    
    // MARK: Album Index
    func getIndex(album: Album)->Int{
        return albums.firstIndex { _album in
            return _album.id == album.id
        } ?? 0
    }
    
    // MARK: Album Card View For Page Tab
    @ViewBuilder
    func AlbumCardView(album: Album)->some View{
        VStack(alignment: .leading, spacing: 6){
            HStack{
                Text("Album")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack(spacing: 5){
                    ForEach(1...5,id: \.self){index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.gray.opacity(index > album.rating ? 0.2 : 1))
                    }
                    
                    Text("\(album.rating).0")
                        .font(.caption)
                        .padding(.leading,5)
                }
            }
            
            Text(album.albumName)
                .font(.title.bold())
            
            Label {
                Text("Ariana Grande")
            } icon: {
                Text("By")
                    .foregroundColor(.gray.opacity(0.7))
            }
            .padding(.top,12)
            
            Text(sampleText)
                .foregroundColor(.gray.opacity(0.7))
                .padding(.top,10)
            
            // MARK: Sample Tags
            HStack(spacing: 10){
                ForEach(["Punk","Classic Rock","Art Rock"],id: \.self){tag in
                    Toggle(tag, isOn: .constant(false))
                        .toggleStyle(.button)
                        .buttonStyle(.bordered)
                        .tint(.gray)
                        .font(.caption)
                }
            }
            .padding(.top)
        }
        .padding(.top,30)
        .padding([.horizontal,.bottom])
        .background{
            CustomCorners(corners: [.bottomLeft,.bottomRight], radius: 25)
                .fill(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal,30)
    }
    
    // MARK: Custom Scroller Animated View
    // Why Using @ViewBuilder Here
    // Since It will update to @State Updates
    @ViewBuilder
    func AlbumArtworkScroller()->some View{
        GeometryReader{proxy in
            let size = proxy.size
            
            // MARK: Showing Before And After Cards
            LazyHStack(spacing: 0){
                ForEach($albums){$album in
                    HStack(spacing: 0){
                        Image(album.albumImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 170, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 10)
                            .zIndex(1)
                        
                        Image("Disk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 160, height: 180)
                        // MARK: Album Image At Center
                            .overlay {
                                Image(album.albumImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                            .rotationEffect(.init(degrees: album.showDisk ? 0 : 40))
                        // MARK: Rotating While Dragging
                            .rotationEffect(.init(degrees: album.diskOffset / -80) * 40)
                            .offset(x: album.showDisk ? 80 : 0)
                            .offset(x: album.showDisk ? album.diskOffset : 0)
                            .scaleEffect(album.showDisk ? 1 : 0.1)
                            .padding(.leading,-170)
                            .zIndex(0)
                    }
                    // 80 / 2 = 40
                    .offset(x: -30)
                    .frame(width: size.width,alignment: currentIndex > getIndex(album: album) ? .trailing : currentIndex == getIndex(album: album) ? .center : .leading)
                    .scaleEffect(currentAlbum.id == album.id ? 1 : 0.8, anchor: .bottom)
                    .offset(x: currentIndex > getIndex(album: album) ? 95 : currentIndex == getIndex(album: album) ? 0 : -45)
                }
            }
            .offset(x: CGFloat(currentIndex) * -size.width)
        }
        .frame(height: 180)
    }
    
    // MARK: Custom View Like a Wooden Board
    var standView: some View{
        Rectangle()
            .fill(.white.opacity(0.6))
            .shadow(color: .black.opacity(0.85), radius: 20, x: 0, y: 5)
            .frame(height: 10)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(.white.opacity(0.75).gradient)
                    .frame(height: 385)
                // MARK: 3D Rotation
                    .rotation3DEffect(.init(degrees: -98), axis: (x: 1, y: 0, z: 0), anchor: .top, anchorZ: 0.5, perspective: 1)
                    .shadow(color: .black.opacity(0.08), radius: 25, x: 0, y: 5)
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 15)
            }
            .scaleEffect(1.5)
    }
    
    // MARK: Attributed String
    var titleString: AttributedString{
        var attString = AttributedString(stringLiteral: "My Library")
        if let range = attString.range(of: "Library"){
            attString[range].font = .largeTitle.bold()
        }
        
        return attString
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


// Custom Extension For Finding Horizontal Offset
extension View{
    func offsetX(completion: @escaping (CGFloat,CGFloat)->())->some View{
        self
            .overlay {
                GeometryReader{proxy in
                    Color.clear
                        .preference(key: OffsetXkey.self, value: proxy.frame(in: .global).minX)
                        .onPreferenceChange(OffsetXkey.self) { value in
                            completion(value,proxy.size.width)
                        }
                }
            }
    }
}

struct OffsetXkey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
