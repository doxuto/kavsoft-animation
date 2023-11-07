//
//  Home.swift
//  DynamicTabIndicator
//
//  Created by Balaji on 15/07/22.
//

import SwiftUI

struct Home: View {
    // MARK: View Properties
    @State var offset: CGFloat = 0
    @State var currentTab: Tab = sampleTabs.first!
    @State var isTapped: Bool = false
    // MARK: Gesture Manager
    @StateObject var gestureManager: InteractionManager = .init()
    var body: some View {
        GeometryReader{proxy in
            let screenSize = proxy.size
            
            ZStack(alignment: .top) {
                // MARK: Page Tab View
                TabView(selection: $currentTab){
                    ForEach(sampleTabs){tab in
                        GeometryReader{proxy in
                            let size = proxy.size
                            
                            Image(tab.sampleImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                        }
                        .ignoresSafeArea()
                        .offsetX { value in
                            // MARK: Calculating Offset With The Help Of Currently Active Tab
                            if currentTab == tab && !isTapped{
                                // To Keep Track of Total Offset
                                // Here is a Trick, Simply Multiply Offset With (Width Of the Tab View * Current Index)
                                offset = value - (screenSize.width * CGFloat(indexOf(tab: tab)))
                            }
                            
                            if value == 0 && isTapped{
                                isTapped = false
                            }
                            
                            // What If User Scrolled Fastly When The Offset Don't Reach 0
                            // WorkAround: Detecting If User Touch The Screen, then Setting  isTapped to False
                            if isTapped && gestureManager.isInteracting{
                                isTapped = false
                            }
                        }
                        .tag(tab)
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear(perform: gestureManager.addGesture)
                .onDisappear(perform: gestureManager.removeGesture)
                
                // MARK: Building Custom Header With Dynamic Tabs
                DynamicTabHeader(size: screenSize)
            }
            .frame(width: screenSize.width, height: screenSize.height)
        }
        .onChange(of: gestureManager.isInteracting) { newValue in
            print(newValue ? "Interacting" : "Stopped")
        }
    }
    
    @ViewBuilder
    func DynamicTabHeader(size: CGSize)->some View{
        VStack(alignment: .leading, spacing: 22) {
            Text("Dynamic Tabs")
                .font(.title.bold())
                .foregroundColor(.white)
            
            // MARK: I'm Going to Show Two Types of Dynamic Tabs
            // MARK: Type 2:
            HStack(spacing: 0){
                ForEach(sampleTabs){tab in
                    Text(tab.tabName)
                        .fontWeight(.semibold)
                        .padding(.vertical,6)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
            }
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(.white)
                    // MARK: Same Technique Followed on Type 1
                    // MARK: For Realistic Tab Change Animation
                    .overlay(alignment: .leading, content: {
                        GeometryReader{_ in
                            HStack(spacing: 0){
                                ForEach(sampleTabs){tab in
                                    Text(tab.tabName)
                                        .fontWeight(.semibold)
                                        .padding(.vertical,6)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .contentShape(Capsule())
                                        .onTapGesture {
                                            // MARK: Disabling The TabScrollOffset Detection
                                            isTapped = true
                                            // MARK: Updating Tab
                                            withAnimation(.easeInOut){
                                                // MARK: It Won't Update
                                                // Because SwiftUI TabView Quickly Updates The Offset
                                                // So Manually Updating It
                                                currentTab = tab
                                                // MARK: Since TabView is Not Padded
                                                offset = -(size.width) * CGFloat(indexOf(tab: tab))
                                            }
                                        }
                                }
                            }
                            // MARK: Simply Reverse The Offset
                            .offset(x: -tabOffset(size: size, padding: 30))
                        }
                        .frame(width: size.width - 30)
                    })
                    .frame(width: (size.width - 30) / CGFloat(sampleTabs.count))
                    .mask({
                        Capsule()
                    })
                    .offset(x: tabOffset(size: size, padding: 30))
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(15)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                // MARK: Dark Mode Only For BG
                .environment(\.colorScheme, .dark)
                .ignoresSafeArea()
        }
    }
    
    // MARK: Tab Offset
    func tabOffset(size: CGSize,padding: CGFloat)->CGFloat{
        return (-offset / size.width) * ((size.width - padding) / CGFloat(sampleTabs.count))
    }
    
    // MARK: Tab Index
    func indexOf(tab: Tab)->Int{
        let index = sampleTabs.firstIndex { CTab in
            CTab == tab
        } ?? 0
        
        return index
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Universal Interaction Manager
class InteractionManager: NSObject,ObservableObject,UIGestureRecognizerDelegate{
    @Published var isInteracting: Bool = false
    @Published var isGestureAdded: Bool = false
    
    func addGesture(){
        if !isGestureAdded{
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(onChange(gesture: )))
            gesture.name = "UNIVERSAL"
            gesture.delegate = self
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
            guard let window = windowScene.windows.last?.rootViewController else{return}
            window.view.addGestureRecognizer(gesture)
            isGestureAdded = true
        }
    }
    
    // MARK: Removing Gesture
    func removeGesture(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
        guard let window = windowScene.windows.last?.rootViewController else{return}
        
        window.view.gestureRecognizers?.removeAll(where: { gesture in
            return gesture.name == "UNIVERSAL"
        })
        isGestureAdded = false
    }
    
    @objc
    func onChange(gesture: UIPanGestureRecognizer){
        isInteracting = (gesture.state == .changed)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// Type 1:
//HStack(spacing: 0){
//    ForEach(sampleTabs){tab in
//        Text(tab.tabName)
//            .fontWeight(.semibold)
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
//    }
//}
//.background(alignment: .bottomLeading) {
//    Capsule()
//        .fill(.white)
//        // MARK: Don't Forgot to Remove Your Padding in Screen Width
//        .frame(width: (size.width - 30) / CGFloat(sampleTabs.count),height: 4)
//        .offset(y: 12)
//    // We Need to Eliminate The Padding
//        .offset(x: tabOffset(size: size, padding: 30))
//}
