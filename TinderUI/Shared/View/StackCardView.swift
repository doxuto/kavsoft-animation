//
//  StackCardView.swift
//  TinderUI (iOS)
//
//  Created by Balaji on 07/12/21.
//

import SwiftUI

struct StackCardView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: User
    
    // Gesture Properties...
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    @State var endSwipe: Bool = false
    
    var body: some View {
        
        GeometryReader{proxy in
            let size = proxy.size
            
            let index = CGFloat(homeData.getIndex(user: user))
            // Showing Next two cards at top like a Stack...
            let topOffset = (index <= 2 ? index : 2) * 15
            
            ZStack{
                
                Image(user.profilePic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                // Reducing width too...
                    .frame(width: size.width - topOffset, height: size.height)
                    .cornerRadius(15)
                    .offset(y: -topOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .gesture(
        
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({ value in
                    
                    let translation = value.translation.width
                    offset = (isDragging ? translation : .zero)
                })
                .onEnded({ value in
                    
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    
                    withAnimation{
                        if checkingStatus > (width / 2){
                            // remove Card...
                            offset = (translation > 0 ? width : -width) * 2
                            endSwipeActions()
                            
                            if translation > 0{
                                rightSwipe()
                            }
                            else{
                                leftSwipe()
                            }
                        }
                        else{
                            // reset..
                            offset = .zero
                        }
                    }
                })
        )
        // Receiving Notifications Posted....
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"), object: nil)) { data in
            
            guard let info = data.userInfo else{
                return
            }
            
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let width = getRect().width - 50
            
            if user.id == id{
                
                // removing card...
                withAnimation{
                    offset = (rightSwipe ? width : -width) * 2
                    endSwipeActions()
                    
                    if rightSwipe{
                        self.rightSwipe()
                    }
                    else{
                        leftSwipe()
                    }
                }
            }
        }
    }
    
    // Rotation...
    func getRotation(angle: Double)->Double{
        
        let rotation = (offset / (getRect().width - 50)) * angle
        
        return rotation
    }
    
    func endSwipeActions(){
        withAnimation(.none){endSwipe = true}
        
        // After the card is moved away removing the card from array to preserve the memory...
        
        // The delay time based on your animation duration...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let _ = homeData.displaying_users?.first{
                
               let _ = withAnimation{
                    homeData.displaying_users?.removeFirst()
                }
            }
        }
    }
    
    func leftSwipe(){
        // DO ACTIONS HERE...
        print("Left Swiped")
    }
    
    func rightSwipe(){
        // DO ACTIONS HERE...
        print("Right Swiped")
    }
}

struct StackCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extending View to get Bounds....
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
