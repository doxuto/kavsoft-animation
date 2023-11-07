//
//  Home.swift
//  QuizGame (iOS)
//
//  Created by Balaji on 14/02/22.
//

import SwiftUI

struct Home: View {
    // MARK: Current Puzzle
    @State var currentPuzzle: Puzzle = puzzles[0]
    @State var selectedLetters: [Letter] = []
    var body: some View {
        
        VStack{
            
            VStack{
                HStack{
                    Button {
                        
                    } label: {
                        Image(systemName: "arrowtriangle.backward.square.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }

                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title3)
                            .padding(10)
                            .background(Color("Blue"),in: Circle())
                            .foregroundColor(.white)
                    }
                }
                .overlay {
                    Text("Level 1")
                        .fontWeight(.bold)
                }
                
                // MARK: Puzzle Image
                Image(currentPuzzle.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: currentPuzzle.imageName == "Justine" ? 100 : 0))
                    .padding(.vertical)
                
                // MARK: Puzzle Fill Blanks
                HStack(spacing: 10){
                    
                    // Why Index?
                    // Bcz it will help to read the selected letters in order
                    // Shown later in the video
                    ForEach(0..<currentPuzzle.answer.count,id: \.self){index in
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Blue").opacity(selectedLetters.count > index ? 1 : 0.2))
                                .frame(height: 60)
                            
                            // Displaying Letters
                            if selectedLetters.count > index{
                                Text(selectedLetters[index].value)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(.white,in: RoundedRectangle(cornerRadius: 15))
            
            // MARK: Custom Honey Comb Grid View
            HoneyCombGridView(items: currentPuzzle.letters) { item in
                // MARK: Hexagon Shape
                ZStack{
                    
                    HexagonShape()
                        .fill(isSelected(letter: item) ? Color("Gold") : .white)
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 10, y: 5)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: 8)
                    
                    Text(item.value)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(isSelected(letter: item) ? .white : .gray.opacity(0.5))
                }
                .contentShape(HexagonShape())
                .onTapGesture {
                    // Adding the Current Letter
                    addLetter(letter: item)
                }
            }
            
            // MARK: Next Button
            Button {
                // Changing into next Puzzle
                selectedLetters.removeAll()
                currentPuzzle = puzzles[1]
                // generating letters for new Puzzle
                generateLetters()
            } label: {
                Text("Next")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color("Gold"),in: RoundedRectangle(cornerRadius: 15))
            }
            .disabled(selectedLetters.count != currentPuzzle.answer.count)
            .opacity(selectedLetters.count != currentPuzzle.answer.count ? 0.6 : 1)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background(Color("BG"))
        .onAppear {
            // Generating Letters
            generateLetters()
        }
    }
    
    func addLetter(letter: Letter){
        
        withAnimation{
            if isSelected(letter: letter){
                // Removing
                selectedLetters.removeAll { currentLetter in
                    return currentLetter.id == letter.id
                }
            }
            else{
                if selectedLetters.count == currentPuzzle.answer.count{return}
                selectedLetters.append(letter)
            }
        }
    }
    
    // Checking if there is one Already
    func isSelected(letter: Letter)->Bool{
        return selectedLetters.contains { currentLetter in
            return currentLetter.id == letter.id
        }
    }
    
    func generateLetters(){
        currentPuzzle.jumbbledWord.forEach { character in
            currentPuzzle.letters.append(Letter(value: String(character)))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
