//
//  Home.swift
//  ComplexMatchedGeometryEffect (iOS)
//
//  Created by Balaji on 01/06/22.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @Namespace var animation
    @State var isExpanded: Bool = false
    @State var expandedProfile: Profile?
    // SEE ANIMATION HACK VIDEO
    @State var loadExpandedContent: Bool = false
    // MARK: Gesture Properties
    @State var offset: CGSize = .zero
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    ForEach(profiles){profile in
                        RowView(profile: profile)
                    }
                }
                .padding()
            }
            .navigationTitle("WhatsApp")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay(content: {
            Rectangle()
                .fill(.black)
                .opacity(loadExpandedContent ? 1 : 0)
                .opacity(offsetProgress())
                .ignoresSafeArea()
        })
        .overlay {
            if let expandedProfile = expandedProfile,isExpanded{
                ExpandedView(profile: expandedProfile)
            }
        }
    }
    
    // MARK: Offset Progress
    func offsetProgress()->CGFloat{
        let progress = offset.height / 100
        if offset.height < 0 {
            return 1
        }else{
            return 1 - (progress < 1 ? progress : 1)
        }
    }
    
    // MARK: Expanded View
    @ViewBuilder
    func ExpandedView(profile: Profile)->some View{
        VStack{
            GeometryReader{proxy in
                let size = proxy.size
                
                Image(profile.profilePicture)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                // IF WE USE CLIP IT WILL CLIP IMAGE FROM TRANSITION
                // TO AVOID IMMEDIATE CLIP RELASE APPLYING CORNER RADIUS
                    .cornerRadius(loadExpandedContent ? 0 : size.height)
                // IF WE USE AFTER CLIP IT WILL UN POSITION THE VIEW
                    .offset(y: loadExpandedContent ? offset.height : .zero)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                offset = value.translation
                            }).onEnded({ value in
                                let height = value.translation.height
                                if height > 0 && height > 100{
                                    // MARK: Closing View
                                    withAnimation(.easeInOut(duration: 0.4)){
                                        loadExpandedContent = false
                                    }
                                    withAnimation(.easeInOut(duration: 0.4).delay(0.05)){
                                        isExpanded = false
                                    }
                                    // MARK: Restting After Animation Completes
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        offset = .zero
                                    }
                                }else{
                                    withAnimation(.easeInOut(duration: 0.4)){
                                        offset = .zero
                                    }
                                }
                            })
                    )
            }
            // WORKAROUND WRAP IT INSIDE GEOMETRY READER AND APPLY BEFORE FRAME
            .matchedGeometryEffect(id: profile.id, in: animation)
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top, content: {
            HStack(spacing: 10){
                Button {
                    withAnimation(.easeInOut(duration: 0.4)){
                        loadExpandedContent = false
                    }
                    withAnimation(.easeInOut(duration: 0.4).delay(0.05)){
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Text(profile.userName)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer(minLength: 10)
            }
            .padding()
            .opacity(loadExpandedContent ? 1 : 0)
            .opacity(offsetProgress())
        })
        // FOR MORE CLEAN TRANSTION USE TRANSTION WITH OFFSET
        // FOR MORE ABOUT MATCHED GEOMETRY TRANSITION
        // SEE ANIMATION VIDEO VIDEO
        // LINK IN DESCRIPTION
        .transition(.offset(x: 0, y: 1))
        .onAppear {
            // DURATION 4 IS FOR TESTING
            withAnimation(.easeInOut(duration: 0.4)){
                loadExpandedContent = true
            }
        }
    }
    
    // MARK: Profile Row View
    @ViewBuilder
    func RowView(profile: Profile)->some View{
        HStack(spacing: 12){
            VStack{
                if expandedProfile?.id == profile.id && isExpanded{
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .cornerRadius(0)
                        .opacity(0)
                }else{
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .matchedGeometryEffect(id: profile.id, in: animation)
                        .cornerRadius(25)
                }
            }
            .onTapGesture {
                // MARK: SAFE USAGE
                if offset != .zero{return}
                withAnimation(.easeInOut(duration: 0.4)){
                    isExpanded = true
                    expandedProfile = profile
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(profile.userName)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(profile.lastMsg)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            Text(profile.lastActive)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
