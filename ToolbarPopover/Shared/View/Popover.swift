//
//  Popover.swift
//  SwipeActionScrollView (iOS)
//
//  Created by Balaji on 13/10/21.
//

import SwiftUI

// Creating Extension for popover...
extension View{
    
    func toolBarPopover<Content: View>(show: Binding<Bool>,placement: Placement = .leading,@ViewBuilder content: @escaping ()->Content)->some View{
        
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
            
                ZStack(alignment: placement == .leading ? .topLeading : .topTrailing){
                    
                    if show.wrappedValue{
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.01))
                            .onTapGesture {
                                
                                withAnimation {
                                    show.wrappedValue.toggle()
                                }
                            }
                        
                        content()
                            .padding()
                            .background(
                            
                                Color.white
                                    .clipShape(PopOverArrowShape(placement: placement))
                            )
                        // Shadows...
                            .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.primary.opacity(0.05), radius: 5, x: -5, y: -5)
                            .padding(.horizontal,35)
                            .padding(.bottom,60)
                        // Moving from top..
                        // Approx Top Nav Bar Height...
                            .offset(y: 55)
                            .offset(x: placement == .leading ? -22 : 22)
                    }
                },
                
                alignment: placement == .leading ? .topLeading : .topTrailing
            )
    }
}

// Placement...
enum Placement{
    case leading
    case trailing
}

struct Popover_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Custom Arrow Shape...
struct PopOverArrowShape: Shape{
    
    var placement: Placement
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: rect.width, y: 0)
            let pt3 = CGPoint(x: rect.width, y: rect.height)
            let pt4 = CGPoint(x: 0, y: rect.height)
            
            // Drawing Arcs with radius...
            path.move(to: pt4)
            
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 15)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 15)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 15)
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 15)
            
            // Arrow...
            
            path.move(to: pt1)
            
            path.addLine(to: CGPoint(x: placement == .leading ? 10 : rect.width - 10, y: 0))
            
            path.addLine(to: CGPoint(x: placement == .leading ? 15 : rect.width - 15, y: 0))
            path.addLine(to: CGPoint(x: placement == .leading ? 25 : rect.width - 25, y: -15))
            path.addLine(to: CGPoint(x: placement == .leading ? 37 : rect.width - 37, y: 0))
        }
    }
}
