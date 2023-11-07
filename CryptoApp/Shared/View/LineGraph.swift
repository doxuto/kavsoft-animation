//
//  LineGraph.swift
//  CustomScrollViewBottomShee (iOS)
//
//  Created by Balaji on 19/09/21.
//

import SwiftUI

// Custom View....
struct LineGraph: View {
    // Number of plots...
    var data: [Double]
    var profit: Bool = false
    
    @State var currentPlot = ""
    
    // Offset...
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    
    @State var translation: CGFloat = 0
    
    @GestureState var isDrag: Bool = false
    
    // Animating Graph
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader{proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                // getting progress and multiplyinh with height...
                // Its Showing From 0
                // Making to show from minimum Amount
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                
                // width..
                let pathWidth = width * CGFloat(item.offset)
                
                // Since we need peak to top not bottom...
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack{
                
                // Converting plot as points....
                
                // Path....
                AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                
                    // Gradient...
                    LinearGradient(colors: [
                    
                        profit ? Color("Profit") : Color("Loss"),
                        profit ? Color("Profit") : Color("Loss"),
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                // Path Bacground Coloring...
                FillBG()
                // Clipping the shape...
                    .clipShape(
                    
                        Path{path in
                            
                            // drawing the points..
                            path.move(to: CGPoint(x: 0, y: 0))
                            
                            path.addLines(points)
                            
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
                    .opacity(graphProgress)
            }
            .overlay(
            
                // Drag Indiccator...
                VStack(spacing: 0){
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .frame(width: 100)
                        .background(Color("Gradient1"),in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1,height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay(
                        
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        )
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1,height: 50)
                }
                // Fixed Frame..
                // For Gesture Calculation...
                    .frame(width: 80,height: 170)
                // 170 / 2 = 85 - 15 => circle ring size...
                    .offset(y: 70)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0),
                
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                
                withAnimation{showPlot = true}
                
                let translation = value.location.x
                
                // Getting index...
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = data[index].convertToCurrency()
                self.translation = translation
                
                // removing half width...
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                
            }).onEnded({ value in
                
                withAnimation{showPlot = false}
                
            }).updating($isDrag, body: { value, out, _ in
                out = true
            }))
        }
        .background(
        
            VStack(alignment: .leading){
                
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                Text(max.convertToCurrency())
                    .font(.caption.bold())
                    .offset(y: -5)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5, content: {
                    Text(min.convertToCurrency())
                        .font(.caption.bold())
                    
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                })
                .offset(y: 25)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
        )
        .padding(.horizontal,10)
        .onChange(of: isDrag) { newValue in
            if !isDrag{showPlot = false}
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)){
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { newValue in
            // MARK: ReAnimating When ever Plot Data Updates
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)){
                    graphProgress = 1
                }
            }
        }
    }
    
    @ViewBuilder
    func FillBG()->some View{
        let color = profit ? Color("Profit") : Color("Loss")
        LinearGradient(colors: [
        
            color
                .opacity(0.3),
            color
                .opacity(0.2),
            color
                .opacity(0.1)]
            + Array(repeating: color
                .opacity(0.1), count: 4)
            + Array(repeating:                     Color.clear, count: 2)
            , startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Animated Path
struct AnimatedGraphPath: Shape{
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat{
        get{return progress}
        set{progress = newValue}
    }
    func path(in rect: CGRect) -> Path {
        Path{path in
            
            // drawing the points..
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}
