//
//  ScoreCardView.swift
//  QuizApp
//
//  Created by Balaji on 16/01/23.
//

import SwiftUI
import FirebaseFirestore

// MARK: Score Card View
struct ScoreCardView: View{
    var score: CGFloat
    /// - Moving to Home When This View was Dismissed
    var onDismiss: ()->()
    @Environment(\.dismiss) private var dismiss
    var body: some View{
        VStack{
            VStack(spacing: 15){
                Text("Result of Your Exercise")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                VStack(spacing: 15){
                    Text("Congratulations! You\n have score")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    /// - Removing Floating Points
                    Text(String(format: "%.0f", score) + "%")
                        .font(.title.bold())
                        .padding(.bottom,10)
                    
                    Image("Medal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 220)
                }
                .foregroundColor(.black)
                .padding(.horizontal,15)
                .padding(.vertical,20)
                .hAlign(.center)
                .background {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.white)
                }
            }
            .vAlign(.center)
            
            CustomButton(title: "Back to Home") {
                /// - Before Closing Updating Attendend People Count on Firestore
                Firestore.firestore().collection("Quiz").document("Info").updateData([
                    "peopleAttended": FieldValue.increment(1.0)
                ])
                onDismiss()
                dismiss()
            }
        }
        .padding(15)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
    }
}
