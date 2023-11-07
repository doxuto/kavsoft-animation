//
//  SplashScreen.swift
//  NetflixSplashScreen
//
//  Created by Balaji on 04/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SplashScreen: View {
    
    @State var animationFinished: Bool = false
    @State var animationStarted: Bool = false
    
    // Stopping GIf after some time...
    @State var removeGIF = false
    
    var body: some View {
        
        ZStack{
            
            Home()
            
            ZStack{
                Color("BG")
                    .ignoresSafeArea()
                
                if !removeGIF{
                    
                    // Overcome...
                    ZStack{
                        
                        if animationStarted{
                            
                            if animationFinished{
                                
                                // Same extract the first frame and set as launch screen image....
                                // Displaying the last frame...
                                // you can easily extract the last frame by....
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            else{
                                AnimatedImage(url: getLogoURL())
                                // no use of using loop count to
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        else{
                            
                            // Showing First Frame..
                            Image("logoStarting")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .animation(.none, value: animationFinished)
                }
                
            }
            .opacity(animationFinished ? 0 : 1)
        }
        .onAppear {
            
            // Delaying intial Start...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                animationStarted = true
             
                // This gif will take time to complete = 1.2s
                // use online tool to calculate the time seconds...
                // So closing the splash screen after 1.5 secs...
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    // Animation has some problems that triggering the gif to reanimate again...
                    withAnimation(.easeInOut(duration: 0.7)){
                        animationFinished = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        removeGIF = true
                    }
                }
            }
        }
    }
    
    func getLogoURL()->URL{
        let bundle = Bundle.main.path(forResource: "logo", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
