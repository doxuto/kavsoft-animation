//
//  Home.swift
//  AdvancedScroll (iOS)
//
//  Created by Balaji on 26/12/21.
//

import SwiftUI

struct Home: View {
    @State var offset: CGFloat = 0
    @StateObject var delegate = ScrollViewDelegate()
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            ScrollContent()
            .padding(.top,getRect().height / 3)
            .padding(.bottom,CGFloat(links.count - 1) * 80)
            .overlay(
            
                GeometryReader{_ in
                    
                    ScrollContent(showTitle: true)
                }
                    .frame(height: 80)
                    .offset(y: offset)
                    .clipped()
                    .background(Color("Yellow"))
                    .padding(.top,getRect().height / 3)
                    .offset(y: -offset)
                
                ,alignment: .top
            )
            .modifier(OffsetModifier(offset: $offset))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("BG"))
        .ignoresSafeArea()
        // MARK: SCrollView Coordinate Name space
        .coordinateSpace(name: "SCROLL")
        // MARK: Setting Delegate
        .onAppear {
            UIScrollView.appearance().delegate = delegate
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().delegate = nil
            UIScrollView.appearance().bounces = true
        }
    }
    
    @ViewBuilder
    func ScrollContent(showTitle: Bool = false)->some View{
        
        VStack(spacing: 0){
            
            ForEach(links){link in
                
                HStack{
                    
                    if showTitle{
                        Text(link.title)
                            .font(.title2.bold())
                            .foregroundColor(Color("BG"))
                            .frame(maxWidth: .infinity,alignment: .leading)
                    }
                    else{
                     
                        Spacer()
                    }
                    
                    Image(link.logo)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(showTitle ? Color("BG") : Color("Yellow"))
                }
                .padding(.horizontal,15)
                .frame(height: 80)
                
            }
        }
        .padding(.top,getSafeArea().top)
        .padding(.bottom,getSafeArea().bottom)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: ScrollView Delegate Manager
class ScrollViewDelegate: NSObject,ObservableObject,UIScrollViewDelegate{
    
    @Published var snapInterval: CGFloat = 80
    
    // MARK: Offset can also be fetched here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let target = scrollView.contentOffset.y
        
        let condition = (target / snapInterval).rounded(.toNearestOrAwayFromZero)

        scrollView.setContentOffset(CGPoint(x: 0, y: snapInterval * condition), animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let target = targetContentOffset.pointee.y
        
        let condition = (target / snapInterval).rounded(.toNearestOrAwayFromZero)

        scrollView.setContentOffset(CGPoint(x: 0, y: snapInterval * condition), animated: true)
    }
}

extension View{
    
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    // MARK: SafeArea Value
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}

// MARK: ScrollView Content Offset
struct OffsetModifier: ViewModifier{
    
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                
                GeometryReader{proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named("SCROLL")).minY)
                }
            }
            .onPreferenceChange(OffsetKey.self) { value in
                self.offset = value
            }
    }
}

// MARK: Content Offset Prefrence Key
struct OffsetKey: PreferenceKey{
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
