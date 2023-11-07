//
//  ContentView.swift
//  IAPGlassfy
//
//  Created by Balaji on 09/11/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var iapModel: IAPViewModel = .init()
    // MARK: User Status
    @AppStorage("premiumUser") var premiumUser: Bool = false
    @State var showPurchaseView: Bool = false
    var body: some View {
        VStack(spacing: 15){
            if premiumUser{
                Text("Premium User")
                
                Button("Manage Subscription"){
                    showPurchaseView.toggle()
                }
            }else{
                Button("Purchase Subscription"){
                    showPurchaseView.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $showPurchaseView) {
            PurchaseView()
                .environmentObject(iapModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
