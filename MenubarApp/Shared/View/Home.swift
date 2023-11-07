//
//  Home.swift
//  MenubarApp (iOS)
//
//  Created by Balaji on 18/04/22.
//

import SwiftUI

// MARK: Integrating My Crypto App with this Menu App
// Check out the Crypto App Video
// Link in Description

struct Home: View {
    @State var currentTab: String = "Crypto"
    @Namespace var animation
    // MARK: App View Model
    @StateObject var appModel: AppViewModel = .init()
    var body: some View {
        VStack{
            CustomSegmentedControl()
                .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10){
                    if let coins = appModel.coins{
                        ForEach(coins){coin in
                            VStack(spacing: 8){
                                CardView(coin: coin)
                                Divider()
                            }
                            .padding(.horizontal)
                            .padding(.vertical,8)
                        }
                    }
                }
            }
            
            HStack{
                Button {
                    
                } label: {
                    Image(systemName: "gearshape.fill")
                }

                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "power")
                }
            }
            .padding(.horizontal)
            .padding(.vertical,10)
            .background{Color.black}
        }
        .frame(width: 320, height: 450)
        .background{Color("BG")}
        .preferredColorScheme(.dark)
        .buttonStyle(.plain)
    }
    
    // MARK: Custom Card View
    @ViewBuilder
    func CardView(coin: CryptoModel)->some View{
        HStack{
            VStack(alignment: .leading, spacing: 6) {
                Text(coin.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 80,alignment: .leading)
            
            LineGraph(data: coin.last_7days_price.price,profit: coin.price_change > 0)
                .padding(.horizontal,10)
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(coin.current_price.convertToCurrency())
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                    .font(.caption)
                    .foregroundColor(coin.price_change > 0 ? Color("LightGreen") : .red)
            }
        }
    }
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomSegmentedControl()->some View{
        HStack(spacing: 0){
            ForEach(["Crypto","Stocks"],id: \.self){tab in
                Text(tab)
                    .fontWeight(currentTab == tab ? .semibold : .regular)
                    .foregroundColor(currentTab == tab ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,6)
                    .background{
                        if currentTab == tab{
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("Tab"))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation{
                            currentTab = tab
                        }
                    }
            }
        }
        .padding(2)
        .background{
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Converting Double to Currency
extension Double{
    func convertToCurrency()->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // Dollar
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
