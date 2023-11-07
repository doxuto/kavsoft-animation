//
//  Home.swift
//  FurnitureAppUI (iOS)
//
//  Created by Balaji on 29/05/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var appModel: AppViewModel
    var animation: Namespace.ID
    // For Easy Calling
    let black: Color = Color("Black")
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15){
                VStack(alignment: .leading, spacing: 8) {
                    Text("Best Furniture")
                        .font(.title.bold())
                    
                    Text("Perfect Choice!")
                        .font(.callout)
                }
                .foregroundColor(Color("Black"))
                .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack(spacing: 12){
                    // MARK: Search Bar
                    HStack(spacing: 12){
                        Image("Search")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(black)
                        
                        TextField("Search", text: .constant(""))
                    }
                    .padding(.horizontal)
                    .padding(.vertical,12)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("Filter")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(black)
                            .frame(width: 25, height: 25)
                            .padding(12)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.white)
                            }
                    }
                }
                
                // MARK: Custom Menu With Matched Geometry Effect
                CustomMenu()
                
                // MARK: Furnitures View
                ForEach(furnitures){furniture in
                    CardView(furniture: furniture)
                }
            }
            .padding()
            // MARK: For Bottom Tab Bar
            .padding(.bottom,100)
        }
    }
    
    // MARK: Furniture Card View
    @ViewBuilder
    func CardView(furniture: Furniture)->some View{
        HStack(spacing: 12){
            Group{
                if appModel.currentActiveItem?.id == furniture.id && appModel.showDetailView{
                    Image(furniture.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0)
                }else{
                    Image(furniture.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: furniture.id + "IMAGE", in: animation)
                }
            }
            .frame(width: 120)
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color("CardBG"))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                // MARK: Text Geometry Effect
                Group{
                    if appModel.currentActiveItem?.id == furniture.id && appModel.showDetailView{
                        Text(furniture.title)
                            .fontWeight(.bold)
                            .foregroundColor(black)
                            .opacity(0)
                        
                        Text("by Seto")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                            .padding(.top,-5)
                            .opacity(0)
                    }else{
                        Text(furniture.title)
                            .fontWeight(.bold)
                            .foregroundColor(black)
                            .matchedGeometryEffect(id: furniture.id + "TITLE", in: animation)
                        
                        Text("by Seto")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                            .matchedGeometryEffect(id: furniture.id + "SUBTITLE", in: animation)
                            .padding(.top,-5)
                    }
                }
                
                Text(furniture.subTitle)
                    .font(.system(size: 14))
                    .foregroundColor(black.opacity(0.8))
                
                HStack{
                    Text(furniture.price)
                        .font(.title3.bold())
                        .foregroundColor(black)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Buy")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical,8)
                            .padding(.horizontal,20)
                            .background{
                                Capsule()
                                    .fill(Color("Orange"))
                            }
                    }
                    .scaleEffect(0.9)
                }
                .offset(y: 10)
            }
            .padding(.vertical,10)
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
        }
        .padding(10)
        .background{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .shadow(color: black.opacity(0.08), radius: 5, x: 5, y: 5)
        }
        .onTapGesture(perform: {
            withAnimation(.easeInOut){
                appModel.currentActiveItem = furniture
                appModel.showDetailView = true
            }
        })
        .padding(.bottom,6)
    }
    
    @ViewBuilder
    func CustomMenu()->some View{
        // Preview Bug
        HStack(spacing: 0){
            ForEach(["All","Chair","Table","Lamp","Floor"],id: \.self){menu in
                Text(menu)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(appModel.currentMenu != menu ? black : .white)
                    .padding(.vertical,8)
                    .frame(maxWidth: .infinity)
                    .background{
                        if appModel.currentMenu == menu{
                            Capsule()
                                .fill(black)
                                .shadow(color: black.opacity(0.1), radius: 5, x: 5, y: 5)
                                .matchedGeometryEffect(id: "MENU", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut){appModel.currentMenu = menu}
                    }
            }
        }
        .padding(.top,10)
        .padding(.bottom,20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
