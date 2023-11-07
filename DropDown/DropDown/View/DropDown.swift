//
//  DropDown.swift
//  DropDown
//
//  Created by Balaji on 10/01/23.
//

import SwiftUI

// MARK: Custom View Builder
struct DropDown: View{
    /// - Drop Down Properties
    var content: [String]
    @Binding var selection: DropDownSelection
    var font: Font = .title3
    var activeTint: Color
    var inActiveTint: Color
    var dynamic: Bool = true
    var height: CGFloat = 55.0
    /// - View Properties
    @State private var expandView: Bool = false
    @State private var disableInteraction: Bool = false
    var body: some View{
        GeometryReader{
            let size = $0.size
            
            VStack(alignment: .leading,spacing: 0){
                if !dynamic{
                    RowView(selection.value, size)
                }
                ForEach(content.filter{
                    dynamic ? true : $0 != selection.value
                },id: \.self){title in
                    RowView(title, size)
                }
            }
            .background {
                Rectangle()
                    .fill(inActiveTint)
            }
            /// - Moving View Based on the Selection
            .offset(y: dynamic ? (CGFloat(content.firstIndex(of: selection.value) ?? 0) * -height) : 0)
        }
        .frame(height: height)
        .overlay(alignment: .trailing) {
            Image(systemName: !dynamic ? "chevron.down" : "chevron.up.chevron.down")
                .rotationEffect(.init(degrees: !dynamic && expandView ? -180 : 0))
                .padding(.trailing,10)
        }
        .mask(alignment: .top){
            Rectangle()
                .frame(height: expandView ? CGFloat(content.count) * height : height)
                /// - Moving the Mask Based on the Selection, so that Every Content Will be Visible
                /// - Visible Only When Content is Expanded
                .offset(y: dynamic && expandView ? (CGFloat(content.firstIndex(of: selection.value) ?? 0) * -height) : 0)
        }
        .background(content: {
            GeometryReader {
                let rect = $0.frame(in: .global)
                Color.primary
                    .opacity(0.001)
                    .onTapGesture {
                        closeView(selection.value)
                    }
                    .offset(x: -rect.minX,y: -rect.minY)
            }
            .frame(width: screenSize.width, height: screenSize.height)
            .position()
            .ignoresSafeArea()
        })
        .zIndex(selection.zIndex)
        .modifier(OptionalClipper(condition: selection.zIndex == 0))
    }
    
    /// - Row View
    @ViewBuilder
    func RowView(_ title: String,_ size: CGSize)->some View{
        let currentIndex = Double(content.firstIndex(of: title) ?? 0)
        Text(title)
            .font(font)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background {
                if selection.value == title{
                    Rectangle()
                        .fill(activeTint)
                        .transition(.identity)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard !disableInteraction else{return}
                /// - If Expanded then Make Selection
                if expandView{
                    closeView(title)
                }else{
                    expandView(title)
                }
                /// - Disabling Interaction While Animating
                disableInteraction = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    disableInteraction = false
                }
            }
            .zIndex(lastSelectionIndex < currentSelectionIndex ? (Double(content.count) - currentIndex) : currentSelectionIndex)
    }
    
    /// - Closes Drop Down View
    func closeView(_ title: String){
        withAnimation(.easeInOut(duration: 0.35)){
            expandView = false
            selection.lastSelection = selection.value
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                selection.zIndex = 0.0
            }
            /// - Disabling Animation for Non-Dynamic Contents
            if dynamic{
                selection.value = title
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    selection.value = title
                }
            }
        }
    }
    
    /// - Expands Drop Down View
    func expandView(_ title: String){
        withAnimation(.easeInOut(duration: 0.35)){
            /// - Disabling Outside Taps
            if selection.value == title{
                selection.zIndex = 1000.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02){
                    withAnimation(.easeInOut(duration: 0.35)){
                        expandView = true
                    }
                }
            }
        }
    }
    
    var lastSelectionIndex: Double{
        return Double(content.firstIndex(of: selection.lastSelection) ?? 0)
    }
    
    var currentSelectionIndex: Double{
        return Double(content.firstIndex(of: selection.value) ?? 0)
    }
}

struct DropDownSelection{
    var value: String
    var lastSelection: String = ""
    var zIndex: Double = 0.0
}

struct OptionalClipper: ViewModifier{
    var condition: Bool = false
    func body(content: Content) -> some View {
        if condition{
            content
                .clipped()
                .contentShape(Rectangle())
        }else{
            content
                .transition(.identity)
        }
    }
}

extension View{
    var screenSize: CGSize{
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size ?? .zero
    }
}

