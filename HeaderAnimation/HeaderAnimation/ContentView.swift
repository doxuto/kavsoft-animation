//
//  ContentView.swift
//  HeaderAnimation
//
//  Created by Balaji on 19/11/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject fileprivate var gestureManager = UniversalGestureManager()
    @Environment(\.isDragging) var isDragging
    var body: some View {
        Home()
            .environment(\.isDragging, gestureManager.isDragging)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

fileprivate class UniversalGestureManager: NSObject, UIGestureRecognizerDelegate,ObservableObject{
    let gestureID = UUID().uuidString
    @Published var isDragging: Bool = false
    
    override init() {
        super.init()
        addGesture()
    }
    
    func addGesture(){
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = gestureID
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(onGestureChange(gesture:)))
        rootWindow.rootViewController?.view.addGestureRecognizer(panGesture)
    }
    
    var rootWindow: UIWindow{
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let window = windowScene.windows.first else{
            return .init()
        }
        
        return window
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer){
        if gesture.state == .changed || gesture.state == .began{
            isDragging = true
        }
        if gesture.state == .ended || gesture.state == .cancelled{
            isDragging = false
        }
    }
}

fileprivate struct UniversalGesture: EnvironmentKey{
    static let defaultValue: Bool = false
}

extension EnvironmentValues{
    var isDragging: Bool{
        get{self[UniversalGesture.self]}
        set{self[UniversalGesture.self] = newValue}
    }
}

