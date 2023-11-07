//
//  OnBoardingScreen.swift
//  AnimatedOnBoardingScreen
//
//  Created by Balaji on 17/12/22.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    // MARK: OnBoarding Slides Model Data
    @State var onboardingItems: [OnboardingItem] = [
        .init(title: "Request Pickup",
              subTitle: "Tell us who you're sending it to, what you're sending and when it's best to pickup the package and we will pick it up at the most convenient time",
              lottieView: .init(name: "Pickup",bundle: .main)),
        .init(title: "Track Delivery",
              subTitle: "The best part starts when our courier is on the way to your location, as you will get real time notifications as to the exact location of the courier",
              lottieView: .init(name: "Transfer",bundle: .main)),
        .init(title: "Receive Package",
              subTitle: "The journey ends when your package get to it's location. Get notified immediately your package is received at its intended location",
              lottieView: .init(name: "Delivery",bundle: .main))
    ]
    // MARK: Current Slide Index
    @State var currentIndex: Int = 0
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            TabView(selection: $currentIndex) {
                ForEach($onboardingItems) { $item in
                    let isLastSlide = (currentIndex == onboardingItems.count - 1 && currentIndex == indexOf(item))
                    VStack{
                        VStack(spacing: 15){
                            // MARK: Resizable Lottie View
                            ResizableLottieView(onboardingItem: $item)
                                .frame(height: size.width)
                                .onAppear {
                                    // MARK: Intially Playing First Slide Animation
                                    if currentIndex == indexOf(item){
                                        item.lottieView.play(toProgress: 0.7)
                                    }
                                }
                            
                            Text(item.title)
                                .font(.title.bold())
                            
                            Text(item.subTitle)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,15)
                                .foregroundColor(.gray)
                        }
                        .padding(.top,50)
                        
                        Spacer(minLength: 0)
                        
                        // MARK: Next / Login Button
                        VStack(spacing: 15){
                            Text(isLastSlide ? "Login" : "Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical,isLastSlide ? 13 : 12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color("Green"))
                                }
                                .padding(.horizontal,isLastSlide ? 30 : 100)
                                .onTapGesture {
                                    // MARK: Updating to Next Index
                                    if currentIndex < onboardingItems.count - 1 {
                                        // MARK: Pausing Previous Animation
                                        let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
                                        onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            currentIndex += 1
                                        }
                                        // MARK: Playing Next Animation from Start
                                        playAnimation()
                                    } else {
                                        print("DO LOGIN ACTION")
                                    }
                                }
                            
                            HStack{
                                Text("Terms of Service")
                                    
                                Text("Privacy Policy")
                            }
                            .font(.caption2)
                            .underline(true, color: .primary)
                            .offset(y: 5)
                        }
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(15)
                    .tag(indexOf(item))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .top, content: {
                // MARK: Top Nav Bar
                HStack{
                    Button("Back"){
                        if currentIndex > 0{
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentIndex -= 1
                            }
                            playAnimation()
                        }
                    }
                    .opacity(currentIndex > 0 ? 1 : 0)
                    
                    Spacer(minLength: 0)
                    
                    Button("Skip"){
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentIndex = onboardingItems.count - 1
                        }
                        playAnimation()
                    }
                    .opacity(currentIndex == onboardingItems.count - 1 ? 0 : 1)
                }
                .animation(.easeInOut, value: currentIndex)
                .tint(Color("Green"))
                .fontWeight(.bold)
                .padding(15)
            })
            .onChange(of: currentIndex) { newValue in
                for index in onboardingItems.indices {
                    if index == currentIndex {
                        playAnimation()
                    } else {
                        onboardingItems[index].lottieView.pause()
                    }
                }
            }
        }
    }
    
    func playAnimation(){
        onboardingItems[currentIndex].lottieView.currentProgress = 0.0
        onboardingItems[currentIndex].lottieView.play(toProgress: 0.7)
    }
    
    // MARK: Retreving Index of the Item in the Array
    func indexOf(_ item: OnboardingItem)->Int{
        if let index = onboardingItems.firstIndex(of: item){
            return index
        }
        return 0
    }
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
