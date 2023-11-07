//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Balaji on 23/11/22.
//

import WidgetKit
import SwiftUI
import Charts

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Crypto {
        Crypto(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (Crypto) -> ()) {
        let entry = Crypto(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        /// Creating Timeline Which will be updated for every 15 Minutes
        let currentDate = Date()
        // Since JSON Parsing using Async
        Task{
            if var cryptoData = try? await fetchData(){
                cryptoData.date = currentDate
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                let timeline = Timeline(entries: [cryptoData], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
    
    // MARK: Fetching JSON Data
    func fetchData()async throws->Crypto{
        let session = URLSession(configuration: .default)
        let response = try await session.data(from: URL(string: APIURL)!)
        let cryptoData = try JSONDecoder().decode([Crypto].self, from: response.0)
        if let crypto = cryptoData.first{
            return crypto
        }
        return .init()
    }
}

// MARK: Live Crypto Data Using JSON API
/// API URL
fileprivate let APIURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=7d"

// MARK: Crypto JSON Model
struct Crypto: TimelineEntry,Codable {
    var date: Date = .init()
    var priceChange: Double = 0.0
    var currentPrice: Double = 0.0
    var last7Days: SparklineData = .init()
    
    enum CodingKeys: String,CodingKey {
        // Since It Uses Different Key Names in API
        case priceChange = "price_change_percentage_7d_in_currency"
        case currentPrice = "current_price"
        case last7Days = "sparkline_in_7d"
    }
}

struct SparklineData: Codable{
    var price: [Double] = []
    
    enum CodingKeys: String,CodingKey {
        case price = "price"
    }
}

struct CryptoWidgetEntryView : View {
    var crypto: Provider.Entry
    // MARK: Use this Environment Property to find out the widget Family
    @Environment(\.widgetFamily) var family

    var body: some View {
        // MARK: Building Widget UI With Swift Charts
        if family == .systemMedium{
            MediumSizedWidget()
        }
        // Other Checks Goes Here
        else{
            LockScreenWidget()
        }
    }
    
    @ViewBuilder
    func LockScreenWidget()->some View{
        VStack(alignment: .leading) {
            HStack{
                Image("Bitcoin Bordered")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading) {
                    Text("Bitcoin")
                        .font(.callout)
                    Text("BTC")
                        .font(.caption2)
                }
            }
            
            HStack{
                Text(crypto.currentPrice.toCurrency())
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(crypto.priceChange.toString(floatingPoint: 1) + "%")
                    .font(.caption2)
            }
        }
    }
    
    @ViewBuilder
    func MediumSizedWidget()->some View{
        ZStack{
            Rectangle()
                .fill(Color("WidgetBackground"))
            
            VStack{
                HStack{
                    Image("Bitcoin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Bitcoin")
                            .foregroundColor(.white)
                        
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text(crypto.currentPrice.toCurrency())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 15){
                    VStack(spacing: 8){
                        Text("This week")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(crypto.priceChange.toString(floatingPoint: 1) + "%")
                            .fontWeight(.semibold)
                            .foregroundColor(crypto.priceChange < 0 ? .red : Color("Green"))
                    }
                    
                    // MARK: Swift Charts
                    Chart {
                        let graphColor = crypto.priceChange < 0 ? Color.red : Color("Green")
                        ForEach(crypto.last7Days.price.indices,id: \.self){index in
                            LineMark(x: .value("Hour", index), y: .value("Price", crypto.last7Days.price[index] - min()))
                                .foregroundStyle(graphColor)
                            // Giving Gradient background Effect
                            AreaMark(x: .value("Hour", index), y: .value("Price", crypto.last7Days.price[index] - min()))
                                .foregroundStyle(.linearGradient(colors: [
                                    graphColor.opacity(0.2),
                                    graphColor.opacity(0.1),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                }
            }
            .padding(.all)
        }
    }
    
    // MARK: Finding Minimum Price Value and applying it to Graph so that it can draw from value 0.
    func min()->Double{
        if let min = crypto.last7Days.price.min(){
            return min
        }
        return 0.0
    }
}

struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CryptoWidgetEntryView(crypto: entry)
        }
        // Configuring Widget Families
        // For Lock Screen Widget
        // Simply Add Accessory Type in the Widget Family
        .supportedFamilies([.systemMedium,.accessoryRectangular])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(crypto: Crypto(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

/// Extensions
extension Double{
    func toCurrency()->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? "$0.00"
    }
    
    
    func toString(floatingPoint: Int)->String{
        let string = String(format: "%.\(floatingPoint)f", self)
        return string
    }
}
