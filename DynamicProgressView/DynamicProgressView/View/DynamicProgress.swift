//
//  DynamicProgress.swift
//  DynamicProgressView
//
//  Created by Balaji on 04/10/22.
//

import SwiftUI

// MARK: Custom Observable Object to Handle Updates
class DynamicProgress: NSObject,ObservableObject{
    // MARK: Progress Bar Properties
    @Published var isAdded: Bool = false
    @Published var hideStatusBar: Bool = false
    
    // MARK: Add/Update/Remove Methods
    func addProgressView(config: ProgressConfig){
        // MARK: Avoiding Multiple Views
        if rootController().view.viewWithTag(1009) == nil{
            let swiftUIView = DynamicProgressView(config: config)
                .environmentObject(self)
            let hostingView = UIHostingController(rootView: swiftUIView)
            // Any Way It's Going to be Full Screen
            hostingView.view.frame = screenSize()
            hostingView.view.backgroundColor = .clear
            // Used for Removal Process
            hostingView.view.tag = 1009
            // Adding it to Root Controller
            rootController().view.addSubview(hostingView.view)
            isAdded = true
        }else{
            print("ALREADY ADDED")
        }
    }
    
    func updateProgressView(to: CGFloat){
        // MARK: Using Notification Center For Updating Progress
        // NOTE: You can Also Directly Use Progress Here, Because It's an Observable Class
        NotificationCenter.default.post(name: NSNotification.Name("UPDATE_PROGRESS"), object: nil,userInfo: [
            "progress": to
        ])
    }
    
    func removeProgressView(){
        if let view = rootController().view.viewWithTag(1009){
            view.removeFromSuperview()
            isAdded = false
            print("REMOVED FROM ROOT")
        }
    }
    
    func removeProgressWithAnimations(){
        NotificationCenter.default.post(name: NSNotification.Name("CLOSE_PROGRESS_VIEW"), object: nil)
    }
    
    func screenSize()->CGRect{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        return window.screen.bounds
    }
    
    func rootController()->UIViewController{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = window.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}

// MARK: Custom Dynamic Island based Progress View
fileprivate
struct DynamicProgressView: View{
    // MARK: Passing Properties
    var config: ProgressConfig
    @EnvironmentObject var progressBar: DynamicProgress
    
    // MARK: Animation Properties
    @State var showProgressView: Bool = false
    @State var progress: CGFloat = 0
    @State var showAlertView: Bool = false
    var body: some View{
        // For More Check Out My Previous Dynamic Island Videos
        Canvas { ctx, size in
            ctx.addFilter(.alphaThreshold(min: 0.5, color: .black))
            ctx.addFilter(.blur(radius: 5.5))
            
            ctx.drawLayer { context in
                for index in [1,2]{
                    if let resolvedImage = ctx.resolveSymbol(id: index){
                        // MARK: Dynamic Area Top Offset = 11
                        // Capsule Height = 37 / 2 -> 18
                        context.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: 11 + 18))
                    }
                }
            }
        } symbols: {
            ProgressComponents()
                .tag(1)
            ProgressComponents(isCircle: true)
                .tag(2)
        }
        .overlay(alignment: .top, content: {
            ProgressView()
                .offset(y: 11)
        })
        .overlay(alignment: .top, content: {
            CustomAlertView()
        })
        .ignoresSafeArea()
        // Since It Will Be An Overlay On Root Controller
        // Disabling Tap Handles To Allow Below Root View to Interact
        .allowsHitTesting(false)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                showProgressView = true
            }
        }
        // MARK: Button Tap Removal
        .onReceive(NotificationCenter.default.publisher(for: .init("CLOSE_PROGRESS_VIEW")), perform: { _ in
            showProgressView = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                progressBar.removeProgressView()
            }
        })
        // MARK: Receiving Notification's
        .onReceive(NotificationCenter.default.publisher(for: .init("UPDATE_PROGRESS"))) { output in
            if let info = output.userInfo,let progress = info["progress"] as? CGFloat{
                if progress < 1.0{
                    self.progress = progress
                    
                    if (progress * 100).rounded() == 100.0{
                        // Pushing back Inside and Presenting Simple Dynamic Island Based Alert
                        showProgressView = false
                        showAlertView = true
                        
                        // MARK: Hiding Status Bar When Half AlertView is Opened
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            progressBar.hideStatusBar = true
                        }
                        
                        // MARK: After 2-3 Sec's Closing Alert and Removing View from Root Controller
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            showAlertView = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                progressBar.hideStatusBar = false
                            }
                            
                            // Animation Timing
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                progressBar.removeProgressView()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Custom Dynamic Island Based Alert View
    @ViewBuilder
    func CustomAlertView()->some View{
        GeometryReader{proxy in
            let size = proxy.size
            
            Capsule()
                .fill(.black)
                .frame(width: showAlertView ? size.width : 125, height: showAlertView ? size.height : 35)
                .overlay(content: {
                    // MARK: Alert Content
                    HStack(spacing: 13){
                        Image(systemName: config.expandedImage)
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                            .foregroundStyle(.white, .blue, .white)
                        
                        HStack(spacing: 6){
                            Text("Downloaded")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(config.title)
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .lineLimit(1)
                        .contentTransition(.opacity)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .offset(y: 12)
                    }
                    .padding(.horizontal,12)
                    .blur(radius: showAlertView ? 0 : 5)
                    .opacity(showAlertView ? 1 : 0)
                })
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        }
        .frame(height: 65)
        .padding(.horizontal, 18)
        .offset(y: showAlertView ? 11 : 12)
        // MARK: Delay For Circle Animation to Finish
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7).delay(showAlertView ? 0.35 : 0), value: showAlertView)
    }
        
    // MARK: Progress View
    @ViewBuilder
    func ProgressView()->some View{
        ZStack{
            // MARK: Image
            // MARK: Adding Rotation If Applicable
            let rotation = (progress > 1 ? 1 : (progress < 0 ? 0 : progress))
            Image(systemName: config.progressImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .fontWeight(.semibold)
                .frame(width: 12, height: 12)
                .foregroundColor(config.tint)
                .rotationEffect(.init(degrees: config.rotationEnabled ? Double(rotation * 360) : 0))
            
            // MARK: Progress Rings
            ZStack{
                Circle()
                    .stroke(.white.opacity(0.25), lineWidth: 4)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(config.tint, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
            }
            .frame(width: 23, height: 23)
        }
        .frame(width: 37, height: 37)
        .frame(width: 126,alignment: .trailing)
        .offset(x: showProgressView ? 45 : 0)
        .opacity(showProgressView ? 1 : 0)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: showProgressView)
    }
    
    // MARK: Progress Bar Components
    @ViewBuilder
    func ProgressComponents(isCircle: Bool = false)->some View{
        if isCircle{
            Circle()
                .fill(.black)
                .frame(width: 37, height: 37)
                .frame(width: 126,alignment: .trailing)
                .offset(x: showProgressView ? 45 : 0)
                // For More Depth Effect
                .scaleEffect(showProgressView ? 1 : 0.55, anchor: .trailing)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: showProgressView)
        }else{
            // MARK: Dynamic Island Size = (126,37)
            Capsule()
                .fill(.black)
                .frame(width: 126,height: 36)
                .offset(y: 1)
        }
    }
}
