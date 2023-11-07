//
//  OrderStatus.swift
//  OrderStatus
//
//  Created by Balaji on 28/07/22.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct OrderStatus: Widget{
    var body: some WidgetConfiguration{
        ActivityConfiguration(attributesType: OrderAttributes.self) { context in
            // MARK: Live Activity View
            
            // NOTE: Live Activity Max Height = 220 pixels.
            ZStack{
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("Green").gradient)
                
                // MARK: Order Status UI
                VStack{
                    HStack{
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                        Text("In store pickup")
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                        HStack(spacing: -2){
                            ForEach(["Burger","Shake"],id: \.self){image in
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .background {
                                        Circle()
                                            .fill(Color("Green"))
                                            .padding(-2)
                                    }
                                    .background {
                                        Circle()
                                            .stroke(.white, lineWidth: 1.5)
                                            .padding(-2)
                                    }
                            }
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 0){
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message(status: context.state.status))
                                .font(.title3)
                                .foregroundColor(.white)
                            Text(subMessage(status: context.state.status))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .offset(y: 13)
                        
                        HStack(alignment: .bottom,spacing: 0){
                            ForEach(Status.allCases,id: \.self){type in
                                Image(systemName: type.rawValue)
                                    .font(context.state.status == type ? .title2 : .body)
                                    .foregroundColor(context.state.status == type ? Color("Green") : .white.opacity(0.7))
                                    .frame(width: context.state.status == type ? 45 : 32, height: context.state.status == type ? 45 : 32)
                                    .background {
                                        Circle()
                                            .fill(context.state.status == type ? .white : .green.opacity(0.5))
                                    }
                                    // MARK: Bottom Arrow To Look Like Bubble
                                    .background(alignment: .bottom, content: {
                                        BottomArrow(status: context.state.status,type: type)
                                    })
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .overlay(alignment: .bottom, content: {
                            // Image Size = 45 + Trailing Padding = 10
                            // 55/2 = 27.5
                            Rectangle()
                                .fill(.white.opacity(0.6))
                                .frame(height: 2)
                                .offset(y: 12)
                                .padding(.horizontal,27.5)
                        })
                        .padding(.leading,15)
                        .padding(.trailing,-10)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxHeight: .infinity,alignment: .bottom)
                    .padding(.bottom,10)
                }
                .padding(15)
            }
        }
    }
    
    // MARK: Spiliting Code
    @ViewBuilder
    func BottomArrow(status: Status,type: Status)->some View{
        Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: 15))
            .scaleEffect(x: 1.3)
            .offset(y: 6)
            .opacity(status == type ? 1 : 0)
            .foregroundColor(.white)
            .overlay(alignment: .bottom) {
                Circle()
                    .fill(.white)
                    .frame(width: 5, height: 5)
                    .offset(y: 13)
            }
    }
    
    // MARK: Main Title
    func message(status: Status)->String{
        switch status {
        case .received:
            return "Order received"
        case .progress:
            return "Order in progress"
        case .ready:
            return "Order ready"
        }
    }
    
    // MARK: Sub Title
    func subMessage(status: Status)->String{
        switch status {
        case .received:
            return "We just received your order."
        case .progress:
            return "We are handcrafting your order."
        case .ready:
            return "We crafted your order."
        }
    }
}
