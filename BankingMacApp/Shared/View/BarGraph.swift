//
//  BarGraph.swift
//  Analytics (iOS)
//
//  Created by Balaji on 01/10/21.
//

import SwiftUI

struct BarGraph: View {
    var analytics: [Analytics]
    var body: some View {
        
        VStack(spacing: 20){
            // Graph View
            GraphView()
                .padding(.top,20)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.top)
    }
    
    @ViewBuilder
    func GraphView()->some View{
        
        GeometryReader{proxy in
            
            ZStack{
                
                VStack(spacing: 0){
                    
                    ForEach(getGraphLines(),id: \.self){line in
                        
                        HStack(spacing: 8){
                            
                            Text("\(Int(line))")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(maxHeight: .infinity,alignment: .bottom)
                        // Removing the text size...
                        .offset(y: -15)
                    }
                }
                
                HStack{
                    ForEach(analytics){download in
                        
                        VStack(spacing: 0){
                            
                            VStack(spacing: 5){
                                
                                Rectangle()
                                    .fill(Color.black)
                            }
                            .frame(width: 30)
                            .frame(height: getBarHeight(point: download.spend, size: proxy.size))
                            
                            Text(download.weekDay)
                                .font(.caption)
                                .frame(height: 25,alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.leading,30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        // Fixed Height
        .frame(height: 190)
    }
    
    func getBarHeight(point: CGFloat,size: CGSize)->CGFloat{
        
        let max = getMax()
        
        // 25 Text Height
        // 5 Spacing..
        let height = (point / max) * (size.height - 37)
        
        return height
    }
    
    // getting Sample Graph Lines based on max Value...
    func getGraphLines()->[CGFloat]{
        
        let max = getMax()
        
        var lines: [CGFloat] = []
        
        lines.append(max)
        
        for index in 1...4{
            
            // dividing the max by 4 and iterating as index for graph lines...
            let progress = max / 4
            
            lines.append(max - (progress * CGFloat(index)))
        }
        
        return lines
    }
    
    // Getting Max....
    func getMax()->CGFloat{
        let max = analytics.max { first, scnd in
            return scnd.spend > first.spend
        }?.spend ?? 0
        
        return max
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
