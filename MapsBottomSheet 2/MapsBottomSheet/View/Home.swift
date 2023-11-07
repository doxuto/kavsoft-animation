//
//  Home.swift
//  MapsBottomSheet
//
//  Created by Balaji on 18/06/22.
//

import SwiftUI
import MapKit

struct Home: View {
    @State var showAnotherSheet: Bool = false
    var body: some View {
        ZStack{
            // MARK: Sample Corrdinate Region
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708), latitudinalMeters: 10000, longitudinalMeters: 10000)
            Map(coordinateRegion: .constant(region))
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        showAnotherSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                    }
                    .padding()
                })
            // MARK: Building Sheet UI
            // Since We Always Need Bottom Sheet At Bottom Setting to True By Default
                .bottomSheet(presentationDetents: [.medium,.large,.height(70)], isPresented: .constant(true), sheetCornerRadius: 20,isTransparentBG: true) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15){
                            TextField("Serach Maps", text: .constant(""))
                                .padding(.vertical,10)
                                .padding(.horizontal)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.ultraThickMaterial)
                                }
                            
                            // MARK: Songs List View
                            SongsList()
                        }
                        .padding()
                        .padding(.top)
                    }
                    .background(content: {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                    })
                    // MARK: In SwiftUI A ViewController Currently Present Only One Sheet
                    // So If We try to Show Another Sheet It Will not Show Up
                    // But There is a Work Around
                    // Simply Insert All Sheets And FullScreenCover Views to Bottom Sheet View
                    // Because its A New View Controller so It can able to Show Another Sheet
                        .sheet(isPresented: $showAnotherSheet) {
                            Text("Hi Settings 👋")
                        }
                } onDismiss: {}
        }
    }
    
    @ViewBuilder
    func SongsList()->some View{
        VStack(spacing: 25){
            ForEach(albums){album in
                HStack(spacing: 12){
                    Text("#\(getIndex(album: album) + 1)")
                        .fontWeight(.semibold)
                    
                    Image(album.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(album.albumName)
                            .fontWeight(.semibold)
                        
                        Label {
                            Text("65,78,909")
                        } icon: {
                            Image(systemName: "beats.headphones")
                        }
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: album.isLiked ? "suit.heart.fill" : "suit.heart")
                            .font(.title3)
                            .foregroundColor(album.isLiked ? .red : .primary)
                    }

                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(.top,15)
    }
    
    // MARK: Album Index
    func getIndex(album: Album)->Int{
        return albums.firstIndex { CAlbum in
            CAlbum.id == album.id
        } ?? 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
