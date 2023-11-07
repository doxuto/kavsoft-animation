//
//  Home.swift
//  QuizApp
//
//  Created by Balaji on 16/01/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Home: View {
    /// - View Properties
    @State private var quizInfo: Info?
    @State private var questions: [Question] = []
    @State private var startQuiz: Bool = false
    var body: some View {
        if let info = quizInfo{
            VStack(spacing: 10){
                Text(info.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .hAlign(.leading)
                
                /// - Custom Label
                CustomLabel("list.bullet.rectangle.portrait", "\(questions.count) Multiple", "Choice Questions")
                    .padding(.top,20)
                
                CustomLabel("person", "\(info.peopleAttended) People", "Attended the exercise")
                    .padding(.top,5)
                
                Divider()
                    .padding(.horizontal,-15)
                    .padding(.top,15)
                
                if !info.rules.isEmpty{
                    RulesView(info.rules)
                }
                
                CustomButton(title: "Start Test", onClick: {
                    startQuiz.toggle()
                })
                .vAlign(.bottom)
            }
            .padding(15)
            .vAlign(.top)
            .fullScreenCover(isPresented: $startQuiz) {
                QuestionsView(info: info, questions: questions){
                    /// - User has Successfully finished the Quiz
                    /// - Thus Update the UI
                    quizInfo?.peopleAttended += 1
                }
            }
        }else{
            /// - Presenting Progress View
            VStack(spacing: 4){
                ProgressView()
                Text("Please Wait")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .task {
                do{
                    try await fetchData()
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// - Rules View
    @ViewBuilder
    func RulesView(_ rules: [String])->some View{
        VStack(alignment: .leading, spacing: 15) {
            Text("Before you start")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom,12)
            
            ForEach(rules,id: \.self){rule in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                        .offset(y: 6)
                    Text(rule)
                        .font(.callout)
                        .lineLimit(3)
                }
            }
        }
    }
    
    /// - Custom Label
    @ViewBuilder
    func CustomLabel(_ image: String,_ title: String,_ subTitle: String)->some View{
        HStack(spacing: 12){
            Image(systemName: image)
                .font(.title3)
                .frame(width: 45, height: 45)
                .background {
                    Circle()
                        .fill(.gray.opacity(0.1))
                        .padding(-1)
                        .background {
                            Circle()
                                .stroke(Color("BG"),lineWidth: 1)
                        }
                }
            
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BG"))
                Text(subTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            .hAlign(.leading)
        }
    }
    
    /// - Fetching Quiz Info and Questions
    func fetchData()async throws{
        try await loginUserAnonymous()
        let info = try await Firestore.firestore().collection("Quiz").document("Info").getDocument().data(as: Info.self)
        let questions = try await Firestore.firestore().collection("Quiz").document("Info").collection("Questions").getDocuments()
            .documents
            .compactMap{
                try $0.data(as: Question.self)
            }
        /// - UI Must be Updated on Main Thread
        await MainActor.run(body: {
            self.quizInfo = info
            self.questions = questions
        })
    }
    
    /// - Login User as Anonymous For Firestore Access (Later You can Implement own user profile with this)
    func loginUserAnonymous()async throws{
        try await Auth.auth().signInAnonymously()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: View Extensions
/// - Useful for moving Views btw HStack and VStack
extension View{
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
}
