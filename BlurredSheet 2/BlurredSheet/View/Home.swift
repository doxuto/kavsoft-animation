//
//  Home.swift
//  BlurredSheet
//
//  Created by Balaji on 14/12/22.
//

import SwiftUI
import MapKit

struct Home: View {
    // MARK: Sheet Property
    @State var showSheet: Bool = false
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: Sample Map Region
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708), latitudinalMeters: 10000, longitudinalMeters: 10000)
            Map(coordinateRegion: .constant(region))
                .ignoresSafeArea()
            
            // MARK: Sheet Button
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "dock.rectangle")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(15)
            .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                
            } content: {
                Text("Hello From Sheets")
                    .presentationDetents([.large,.medium,.height(150)])
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
