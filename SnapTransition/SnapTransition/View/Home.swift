//
//  Home.swift
//  SnapTransition
//
//  Created by Balaji on 18/01/23.
//

import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var videoFiles: [VideoFile] = files
    @State private var expandedID: String?
    @State private var isExpanded: Bool = false
    @Namespace private var namespace
    var body: some View {
        VStack(spacing: 0){
            HeaderView()
            
            /// - Lazy Grid
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 10), count: 2), spacing: 10) {
                    ForEach($videoFiles) { $file in
                        if expandedID == file.id.uuidString && isExpanded{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 300)
                        }else{
                            CardView(videoFile: $file, isExpanded: $isExpanded, animationID: namespace) {
                                /// - We're going to leave this empty
                            }
                            .frame(height: 300)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)){
                                    expandedID = file.id.uuidString
                                    isExpanded = true
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal,15)
                .padding(.vertical,10)
            }
        }
        .overlay {
            if let expandedID,isExpanded{
                /// Displaying Detail View With Animation
                DetailView(videoFile: $videoFiles.index(expandedID), isExpanded: $isExpanded, animationID: namespace)
                /// - Adding Transition for Smooth Expansion
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
    }
    
    /// - Header View
    @ViewBuilder
    func HeaderView()->some View{
        HStack(spacing: 12){
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .headerButtonBG()
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .headerButtonBG()
            }

            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.badge.plus")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .headerButtonBG()
            }
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .headerButtonBG()
            }
        }
        .overlay(content: {
            Text("Stories")
                .font(.title3)
                .fontWeight(.black)
        })
        .padding(.horizontal,15)
        .padding(.vertical,10)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// - Fetching Binding indexOf
extension Binding<[VideoFile]>{
    func index(_ id: String)->Binding<VideoFile>{
        let index = self.wrappedValue.firstIndex { item in
            item.id.uuidString == id
        } ?? 0
        return self[index]
    }
}

/// - Custom View Modifiers
extension View{
    func headerButtonBG()->some View{
        self
            .frame(width: 40, height: 40)
            .background {
                Circle()
                    .fill(.gray.opacity(0.1))
            }
    }
}
