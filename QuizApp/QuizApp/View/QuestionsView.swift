//
//  QuestionsView.swift
//  QuizApp
//
//  Created by Balaji on 16/01/23.
//

import SwiftUI

struct QuestionsView: View {
    var info: Info
    /// - Making it a State, so that we can do View Modifications
    @State var questions: [Question]
    var onFinish: ()->()
    /// - View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var progress: CGFloat = 0
    @State private var currentIndex: Int = 0
    @State private var score: CGFloat = 0
    @State private var showScoreCard: Bool = false
    var body: some View {
        VStack(spacing: 15){
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .hAlign(.leading)

            Text(info.title)
                .font(.title)
                .fontWeight(.semibold)
                .hAlign(.leading)
            
            GeometryReader{
                let size = $0.size
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.black.opacity(0.2))
                    
                    Rectangle()
                        .fill(Color("Progress"))
                        .frame(width: progress * size.width,alignment: .leading)
                }
                .clipShape(Capsule())
            }
            .frame(height: 20)
            .padding(.top,5)
            
            /// - Questions
            GeometryReader{_ in
                ForEach(questions.indices,id: \.self) { index in
                    /// - We're going to Simply Use Transitions for Moving Forth and Between Instead of Using TabView
                    if currentIndex == index{
                        QuestionView(questions[currentIndex])
                            /// - You Can Change Any Transition you want
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
            }
            /// - Removing Padding
            .padding(.horizontal,-15)
            .padding(.vertical,15)
            
            /// - Changing Button to Finish When the Last Question Arrived
            CustomButton(title: currentIndex == (questions.count - 1) ? "Finish" : "Next Question") {
                if currentIndex == (questions.count - 1){
                    /// - Presenting Score Card View
                    showScoreCard.toggle()
                }else{
                    withAnimation(.easeInOut){
                        currentIndex += 1
                        progress = CGFloat(currentIndex) / CGFloat(questions.count - 1)
                    }
                }
            }
            .disabled(questions[currentIndex].tappedAnswer == "")
            .opacity(questions[currentIndex].tappedAnswer == "" ? 0.5 : 1)
        }
        .padding(15)
        .hAlign(.center).vAlign(.top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        /// This View is going to be Dark Since our background is Dark
        .environment(\.colorScheme, .dark)
        .fullScreenCover(isPresented: $showScoreCard) {
            /// - Displaying in 100%
            ScoreCardView(score: score / CGFloat(questions.count) * 100){
                /// - Closing View
                dismiss()
                onFinish()
            }
        }
    }
    
    /// - Question View
    @ViewBuilder
    func QuestionView(_ question: Question)->some View{
        VStack(alignment: .leading, spacing: 15) {
            Text("Question \(currentIndex + 1)/\(questions.count)")
                .font(.callout)
                .foregroundColor(.gray)
                .hAlign(.leading)
            
            Text(question.question)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            VStack(spacing: 12){
                ForEach(question.options,id: \.self){option in
                    /// - Displaying Correct and Wrong Answers After user has Tapped any one of the Options
                    ZStack{
                        OptionView(option, .gray)
                            .opacity(question.answer == option && question.tappedAnswer != "" ? 0 : 1)
                        OptionView(option, .green)
                            .opacity(question.answer == option && question.tappedAnswer != "" ? 1 : 0)
                        OptionView(option, .red)
                            .opacity(question.tappedAnswer == option && question.tappedAnswer != question.answer ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        /// -Disabling Tap if already Answer was Selected
                        guard questions[currentIndex].tappedAnswer == "" else{return}
                        withAnimation(.easeInOut){
                            questions[currentIndex].tappedAnswer = option
                            /// - When ever the Correct Answer was selected, Updating the Score
                            if question.answer == option{
                                score += 1.0
                            }
                        }
                    }
                }
            }
            .padding(.vertical,10)
        }
        .padding(15)
        .hAlign(.center)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
        }
        .padding(.horizontal,15)
    }
    
    /// - Option View
    @ViewBuilder
    func OptionView(_ option: String,_ tint: Color)->some View{
        Text(option)
            .foregroundColor(tint)
            .padding(.horizontal,15)
            .padding(.vertical,20)
            .hAlign(.leading)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.15))
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(tint.opacity(tint == .gray ? 0.15 : 1),lineWidth: 2)
                    }
            }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
