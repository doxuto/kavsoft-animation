//
//  Home.swift
//  Drag_Drop (iOS)
//
//  Created by Balaji on 27/03/22.
//

import SwiftUI

struct Home: View {
    // MARK: Properties
    @State var progress: CGFloat = 0
    @State var characters: [Character] = characters_
    
    // MARK: Custom Grid Arrays
    // For Drag Part
    @State var shuffledRows: [[Character]] = []
    // For Drop Part
    @State var rows: [[Character]] = []
    
    // Animation
    @State var animateWrongText: Bool = false
    @State var droppedCount: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 15){
            NavBar()
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Form this sentence")
                    .font(.title2.bold())
                
                Image("Character")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing,100)
            }
            .padding(.top,30)
            
            // MARK: Drag Drop Area
            DropArea()
                .padding(.vertical,30)
            DragArea()
            
            if progress == 1{
                Button {
                    
                } label: {
                 
                    Text("Horrah Completed!")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background{
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color("Green"))
                        }
                }
                .padding(.top,30)
            }
        }
        .padding()
        .onAppear {
            if rows.isEmpty{
                // First Creating Shuffled One
                // Then Normal One
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                characters = characters_
                rows = generateGrid()
            }
        }
        .offset(x: animateWrongText ? -30 : 0)
    }
    
    // MARK: Drop Area
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 12){
            ForEach($rows,id: \.self){$row in
                HStack(spacing: 10){
                    ForEach($row){$item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .opacity(item.isShowing ? 1 : 0)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                            .background{
                                // If Item is Dropped into Correct Place
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1 : 0)
                            }
                        // MARK: Adding Drop Operation
                            .onDrop(of: [.url], isTargeted: .constant(false)) { providers in
                                
                                if let first = providers.first{
                                   let _ = first.loadObject(ofClass: URL.self) { value,error in
                                        
                                       guard let url = value else{return}
                                       if item.id == "\(url)"{
                                           droppedCount += 1
                                           let progress = (droppedCount / CGFloat(characters.count))
                                           withAnimation{
                                               item.isShowing = true
                                               updateShuffledArray(character: item)
                                               self.progress = progress
                                           }
                                       }
                                       else{
                                           // Animating When Wrong Text Dropped
                                           animateView()
                                       }
                                    }
                                }
                                
                                return false
                            }
                    }
                }
                
                if rows.last != row{
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    func DragArea()->some View{
        VStack(spacing: 12){
            ForEach(shuffledRows,id: \.self){row in
                HStack(spacing: 10){
                    ForEach(row){item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                        // MARK: Adding Drag Operation
                            .onDrag{
                                // Returning ID to find which Item is Moving
                                return .init(contentsOf: URL(string: item.id))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                    }
                }
                
                if shuffledRows.last != row{
                    Divider()
                }
            }
        }
    }
    
    // MARK: Custom Nav Bar
    @ViewBuilder
    func NavBar()->some View{
        HStack(spacing: 18){
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }

            GeometryReader{proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.gray.opacity(0.25))
                    
                    Capsule()
                        .fill(Color("Green"))
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 20)
            
            Button {
                
            } label: {
                Image(systemName: "suit.heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
    }
    
    // MARK: Generating Custom Grid Columns
    func generateGrid()->[[Character]]{
        // Step 1
        // Identifying Each Text Width and updating it into State Variable
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
        }
        
        var gridArray: [[Character]] = []
        var tempArray: [Character] = []
        
        // Current Width
        var currentWidth: CGFloat = 0
        // -30 -> Horizontal Padding
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in characters {
            currentWidth += character.textSize
            
            if currentWidth < totalScreenWidth{
                tempArray.append(character)
            }
            else{
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        // Checking Exhaust
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        
        return gridArray
    }
    
    // MARK: Identifying Text Size
    func textSize(character: Character)->CGFloat{
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        // Horizontal Padding
        // Adding HStack Spacing
        return size.width + (character.padding * 2) + 15
    }
    
    // MARK: Updating Shuffled Array
    func updateShuffledArray(character: Character){
        for index in shuffledRows.indices{
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == character.id{
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    // MARK: Animating View when Wrong Text Dropped
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateWrongText = false
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
