//
//  ReceiptView.swift
//  ImageRenderer-PDF
//
//  Created by Balaji on 26/06/22.
//

import SwiftUI

struct ReceiptView: View {
    var body: some View {
        VStack{
            VStack(spacing: 10){
                Image(systemName: "checkmark.circle.fill")
                    .font(.title.bold())
                    .foregroundColor(.green)
                Text("Payment Received")
                    .fontWeight(.black)
                    .foregroundColor(.green)
                Text("$150.698")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15){
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .padding(10)
                        .background {
                            Circle()
                                .fill(.white.shadow(
                                    .drop(color: .black.opacity(0.05), radius: 5)
                                ))
                        }
                    
                    Text("The Anaheim Hotel")
                        .font(.title3.bold())
                        .padding(.bottom,12)
                    
                    LabeledContent {
                        Text("$150.698")
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.6))
                    } label: {
                        Text("Total Bill")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .foregroundColor(.gray)
                    }

                    LabeledContent {
                        Text("$0.00")
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.6))
                    } label: {
                        Text("Total Tax")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .foregroundColor(.gray)
                    }
                    
                    Label {
                        Text("You Got 240 Points!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("Purple"))
                    } icon: {
                        Image("Prize")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.vertical,8)
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("Purple").opacity(0.08))
                    }
                    .padding(.top,5)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(
                            .white.shadow(
                                .drop(color: .black.opacity(0.05), radius: 10, x: 5, y: 5)
                            ).shadow(
                                .drop(color: .black.opacity(0.05), radius: 35, x: -5, y: -5)
                            )
                        )
                        .padding(.top,55)
                }
                
                Text("Transaction Details")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top)
                
                VStack(spacing: 16){
                    LabeledContent {
                        Text("Apple Pay")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Payment Method")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    LabeledContent {
                        Text("In Process")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Status")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    LabeledContent {
                        Text("Apple Pay")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Payment Method")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    LabeledContent {
                        Text("25 Jun, 2022")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Transaction Date")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                    
                    LabeledContent {
                        Text("9:25 PM")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    } label: {
                        Text("Transaction Time")
                            .foregroundColor(.gray)
                    }
                    .opacity(0.7)
                }
                .padding(.top)
            }
            .padding()
            .background {
                Color.white
                    .ignoresSafeArea()
            }
            
            LabeledContent {
                Text("$150.698")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            } label: {
                Text("Total Payment")
                    .foregroundColor(.gray)
            }
            .opacity(0.7)
            .padding()
            .background {
                Color.white
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
