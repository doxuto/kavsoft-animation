//
//  Home.swift
//  NotesMacOS (iOS)
//
//  Created by Balaji on 05/10/21.
//

import SwiftUI

struct Home: View {
    
    // Showing Card Colors on Button Click....
    @State var showColors: Bool = false
    
    // Button Animation...
    @State var animateButton: Bool = false
    
    var body: some View {
        
        HStack(spacing: 0){
            
            // Side Bar....
            if isMacOS(){
                Group{
                    SideBar()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 1)
                }
            }
            
            // Main Content....
            MainContent()
        }
        #if os(macOS)
        .ignoresSafeArea()
        #endif
        .frame(width: isMacOS() ? getRect().width / 1.7 : nil, height: isMacOS() ? getRect().height - 180 : nil,alignment: .leading)
        .background(Color("BG").ignoresSafeArea())
        #if os(iOS)
        .overlay(SideBar())
        #endif
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func MainContent()->some View{
        
        VStack(spacing: 6){
            
            // Search Bar...
            HStack(spacing: 8){
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                TextField("Search", text: .constant(""))
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.bottom,isMacOS() ? 0 : 10)
            .overlay(
            
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal,-25)
                // Moving offset 6...
                    .offset(y: 6)
                    .opacity(isMacOS() ? 0 : 1),
                
                alignment: .bottom
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    Text("Notes")
                        .font(isMacOS() ? .system(size: 33, weight: .bold) : .largeTitle.bold())
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    // Columns...
                    let columns = Array(repeating: GridItem(.flexible(), spacing: isMacOS() ? 25 : 15), count: isMacOS() ? 3 : 1)
                    
                    LazyVGrid(columns: columns,spacing: 25) {
                        
                        // Notes...
                        ForEach(notes){note in
                            
                            // Card View....
                            CardView(note: note)
                        }
                    }
                    .padding(.top,30)
                }
                .padding(.top,isMacOS() ? 45 : 30)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .padding(.top,isMacOS() ? 40 : 15)
        .padding(.horizontal,25)
    }
    
    @ViewBuilder
    func CardView(note: Note)->some View{
        
        VStack{
            
            Text(note.note)
                .font(isMacOS() ? .title3 : .body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            HStack{
                
                Text(note.date,style: .date)
                    .foregroundColor(.black)
                    .opacity(0.8)
                
                Spacer(minLength: 0)
                
                // Edit Button...
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .bold))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .clipShape(Circle())
                }

            }
            .padding(.top,55)
        }
        .padding()
        .background(note.cardColor)
        .cornerRadius(18)
    }
    
    @ViewBuilder
    func SideBar()->some View{
        
        VStack{
            
            if isMacOS(){
                Text("Pocket")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // Add Button...
            if isMacOS(){
                AddButton()
                    .zIndex(1)
            }
            
            VStack(spacing: 15){
                
                // Colors...
                let colors = [Color("Skin"),Color("Orange"),Color("Purple"),Color("Blue"),Color("Green")]
                
                ForEach(colors,id: \.self){color in
                    
                    Circle()
                        .fill(color)
                        .frame(width: isMacOS() ? 20 : 25, height: isMacOS() ? 20 : 25)
                }
            }
            .padding(.top,20)
            .frame(height: showColors ? nil : 0)
            .opacity(showColors ? 1 : 0)
            .zIndex(0)
            
            if !isMacOS(){
                AddButton()
                    .zIndex(1)
            }
        }
        #if os(macOS)
        .frame(maxHeight: .infinity,alignment: .top)
        .padding(.vertical)
        .padding(.horizontal,22)
        .padding(.top,35)
        #else
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        .padding()
        // Blur View...
        .background(
            BlurView(style: .systemUltraThinMaterialDark)
                .opacity(showColors ? 1 : 0)
                .ignoresSafeArea()
        )
        #endif
    }
    
    @ViewBuilder
    func AddButton()->some View{
        Button {
            
            if animateButton{return}
            
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                showColors.toggle()
                animateButton.toggle()
            }
            
            // Resetting the button...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                withAnimation(.spring()){
                    animateButton.toggle()
                }
            }
            
        } label: {
            
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .scaleEffect(animateButton ? 1.1 : 1)
                .rotationEffect(.init(degrees: showColors ? 45 : 0))
                .padding(isMacOS() ? 12 : 15)
                .background(Color.black)
                .clipShape(Circle())
        }
        .scaleEffect(animateButton ? 1.1 : 1)
        .padding(.top,30)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// Extending View to get Frame and getting device os Types...
extension View{
    
    func getRect()->CGRect{
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main!.visibleFrame
        #endif
    }
    
    func isMacOS()->Bool{
        #if os(iOS)
        return false
        #endif
        return true
    }
}
