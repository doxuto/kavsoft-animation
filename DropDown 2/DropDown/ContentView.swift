//
//  ContentView.swift
//  DropDown
//
//  Created by Balaji on 07/01/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String = "Easy"
    @Environment(\.colorScheme) var scheme
    var body: some View {
        VStack{
            DropDown(
                content: ["Easy","Normal","Hard","Expert"],
                selection: $selection,
                activeTint: .primary.opacity(0.1),
                inActiveTint: .primary.opacity(0.05),
                dynamic: true
            )
            .frame(width: 130)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
        .background {
            if scheme == .dark{
                Color("BG")
                    .ignoresSafeArea()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Custom View Builder
struct DropDown: View{
    /// - Drop Down Properties
    var content: [String]
    @Binding var selection: String
    var activeTint: Color
    var inActiveTint: Color
    var dynamic: Bool = true
    /// - View Properties
    @State private var expandView: Bool = false
    @State private var disableInteraction: Bool = false
    var body: some View{
        GeometryReader{
            let size = $0.size
            
            VStack(alignment: .leading,spacing: 0){
                if !dynamic{
                    RowView(selection, size)
                }
                ForEach(content.filter{
                    dynamic ? true : $0 != selection
                },id: \.self){title in
                    RowView(title, size)
                }
            }
            .background {
                Rectangle()
                    .fill(inActiveTint)
            }
            /// - Moving View Based on the Selection
            .offset(y: dynamic ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -55) : 0)
        }
        .frame(height: 55)
        .overlay(alignment: .trailing) {
            Image(systemName: !dynamic ? "chevron.down" : "chevron.up.chevron.down")
                .rotationEffect(.init(degrees: !dynamic && expandView ? -180 : 0))
                .padding(.trailing,10)
        }
        .mask(alignment: .top){
            Rectangle()
                .frame(height: expandView ? CGFloat(content.count) * 55 : 55)
                /// - Moving the Mask Based on the Selection, so that Every Content Will be Visible
                /// - Visible Only When Content is Expanded
                .offset(y: dynamic && expandView ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -55) : 0)
        }
        .zIndex(1000.0)
    }
    
    /// - Row View
    @ViewBuilder
    func RowView(_ title: String,_ size: CGSize)->some View{
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background {
                if selection == title{
                    Rectangle()
                        .fill(activeTint)
                        .transition(.identity)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard !disableInteraction else{return}
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                    /// - If Expanded then Make Selection
                    if expandView{
                        expandView = false
                        /// - Disabling Animation for Non-Dynamic Contents
                        if dynamic{
                            selection = title
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                                selection = title
                            }
                        }
                    }else{
                        /// - Disabling Outside Taps
                        if selection == title{
                            expandView = true
                        }
                    }
                    /// - Disabling Interaction While Animating
                    disableInteraction = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                        disableInteraction = false
                    }
                }
            }
    }
}
