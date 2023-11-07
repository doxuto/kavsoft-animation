//
//  FitnessStepsGraphView.swift
//  MinimalAnimation-2 (iOS)
//
//  Created by Balaji on 11/03/22.
//

import SwiftUI

struct FitnessStepsGraphView: View {
    var body: some View {
        VStack(spacing: 15){
            Text("Steps by hours")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            // Bar Graph
            // See my analytics App UI Video for bar graph implementation
            // Link in Description
            BarGraph(steps: steps)
        }
        .padding(.horizontal,20)
        .padding(.vertical,25)
        .background{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }
}

struct FitnessStepsGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Modifying for our Usage

struct BarGraph: View {
    var steps: [Step]
    var body: some View {
        // Graph View
        GraphView()
            .padding(.top,20)
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
                    ForEach(steps.indices,id: \.self){index in
                        let step = steps[index]
                        
                        VStack(spacing: 0){
                            
                            VStack(spacing: 5){
                                
                                AnimatedBarGraph(step: steps[index], index: index)
                            }
                            .padding(.horizontal,5)
                            .frame(height: getBarHeight(point: step.value, size: proxy.size))
                            
                            Text(
                                step.key
                                    .replacingOccurrences(of: " AM", with: "")
                                    .replacingOccurrences(of: " PM", with: "")
                            )
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
        let max = steps.max { first, scnd in
            return scnd.value > first.value
        }?.value ?? 0
        
        return max
    }
}

struct AnimatedBarGraph: View{
    var step: Step
    var index: Int
    
    @State var showBar: Bool = false
    
    var body: some View{
        VStack(spacing: 0){
            Spacer(minLength: 0)
            
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(step.color)
                .frame(height: showBar ? nil : 0,alignment: .bottom)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.1)){
                    showBar = true
                }
            }
        }
    }
}
