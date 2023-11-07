//
//  Home.swift
//  Magnification
//
//  Created by Balaji on 29/11/22.
//

import SwiftUI

struct Home: View {
    // MARK: Magnification Properties
    @State var scale: CGFloat = 0
    @State var rotation: CGFloat = 0
    @State var size: CGFloat = -20
    @State var hideGlass: Bool = false
    var body: some View {
        VStack(spacing: 0){
            GeometryReader{
                let size = $0.size
                
                Image("SS")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                    /// Adding Magnification Modifier
                    .magnificationEffect(scale, rotation, self.size,Color("Color").opacity(hideGlass ? 0 : 1))
            }
            .padding(40)
            .contentShape(Rectangle())
            
            // MARK: Customization Options
            VStack(alignment: .leading, spacing: 0) {
                Text("Customizations")
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.bottom,20)
                
                HStack(spacing: 14){
                    Text("Scale")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35,alignment: .leading)
                    
                    Slider(value: $scale)
                    
                    Text("Rotation")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Slider(value: $rotation)
                }
                .tint(.black)
                
                HStack(spacing: 14){
                    Text("Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35,alignment: .leading)
                    
                    Slider(value: $size,in: -20...100)
                }
                .tint(.black)
                .padding(.vertical)
                
                Toggle("Hide Glass", isOn: $hideGlass)
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white)
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(content: {
            Color.black
                .opacity(0.08)
                .ignoresSafeArea()
        })
        .preferredColorScheme(.light)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
