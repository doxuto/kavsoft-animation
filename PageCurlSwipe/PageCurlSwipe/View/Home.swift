//
//  Home.swift
//  PageCurlSwipe
//
//  Created by Balaji on 23/03/23.
//

import SwiftUI

struct Home: View {
    /// Sample Images For Displaying
    @State private var images: [ImageModel] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                //SampleView()
                
                ForEach(images) { image in
                    PeelEffect {
                        CardView(image)
                    } onDelete: {
                        /// Deleting Card
                        if let index = images.firstIndex(where: { C1 in
                            C1.id == image.id
                        }) {
                            let _ = withAnimation(.easeInOut(duration: 0.35)) {
                                images.remove(at: index)
                            }
                        }
                    }
                }
            }
            .padding(15)
        }
        .onAppear {
            for index in 1...4 {
                images.append(.init(assetName: "Pic \(index)"))
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ imageModel: ImageModel) -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                Image(imageModel.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
    
    /// Multi View Sample Demo
    @ViewBuilder
    func SampleView() -> some View{
        PeelEffect {
            HStack(spacing: 15) {
                Text("$1299")
                    .fontWeight(.semibold)
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text("iJustine")
                        .fontWeight(.semibold)
                    
                    Text("iMac")
                        .font(.caption)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text("J")
                    .font(.title.bold())
                    .frame(width: 45, height: 45)
                    .background {
                        Circle()
                            .fill(.red.gradient)
                    }
            }
            .foregroundColor(.white)
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.purple.gradient)
            }
        } onDelete: {
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Sample Model For Displaying Images
struct ImageModel: Identifiable {
    var id: UUID = .init()
    var assetName: String
}
