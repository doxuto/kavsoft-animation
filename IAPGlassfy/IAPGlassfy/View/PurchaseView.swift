//
//  PurchaseView.swift
//  IAPGlassfy
//
//  Created by Balaji on 10/11/22.
//

import SwiftUI
import Glassfy

struct PurchaseView: View {
    @EnvironmentObject var iapModel: IAPViewModel
    @Environment(\.dismiss) var dismiss
    @AppStorage("premiumUser") var premiumUser: Bool = false
    var body: some View {
        // MARK: Building Purchase UI
        VStack{
            Text("Glassfy")
                .font(.largeTitle)
                .fontWeight(.black)
                .overlay(alignment: .bottomTrailing) {
                    Text("MEMBERSHIP")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal,4)
                        .padding(.vertical,2)
                        .background {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.black)
                        }
                        .offset(x: 15, y: 20)
                }
            
            Image("Icon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.top,35)
            
            VStack(spacing: 30){
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry")
                
                Text("Lorem Ipsum is simply random text")
            }
            .frame(maxHeight: .infinity)
            .font(.title3)
            .multilineTextAlignment(.center)
            
            if premiumUser{
                // MARK: Manage Subscription Button
                VStack(spacing: 15){
                    Text("You've already purchased Membership !!!")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        
                    } label: {
                        Text("Manage Membership")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical,12)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.black.gradient)
                            }
                    }
                }
            }else{
                // MARK: Product Display
                VStack(spacing: 12){
                    Button {
                        iapModel.restorePurchase()
                    } label: {
                        HStack(spacing: 10){
                            Image(systemName: "clock.arrow.2.circlepath")
                                .font(.caption)
                            
                            Text("Restore Purchases")
                                .font(.callout)
                        }
                        .foregroundColor(.black)
                        .padding(.vertical,10)
                    }

                    ForEach(iapModel.products,id: \.self){product in
                        ProductView(prodcut: product)
                    }
                }
            }
            
            Link("Terms of Service & Privacy Policy", destination: URL(string: "https://www.google.com")!)
                .font(.caption)
                .foregroundColor(.black)
                .padding(.top,10)
        }
        .padding([.horizontal,.top])
        .padding(.bottom,10)
        .frame(maxHeight: .infinity,alignment: .top)
        .opacity(iapModel.products.isEmpty ? 0 : 1)
        .overlay {
            ProgressView()
                .opacity(iapModel.products.isEmpty ? 1 : 0)
        }
        .alert(iapModel.errorMessage, isPresented: $iapModel.showError) {
        }
        .overlay(alignment: .topLeading, content: {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(10)
            }
        })
        .overlay {
            if iapModel.isLoading{
                ZStack{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    ProgressView()
                }
                .ignoresSafeArea()
                .animation(.easeInOut, value: iapModel.isLoading)
            }
        }
        .background {
            Color.black
                .opacity(0.04)
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func ProductView(prodcut: Glassfy.Sku)->some View{
        Button {
            iapModel.purchase(product: prodcut)
        } label: {
            let productID = prodcut.product.productIdentifier
            let duration = productID == "com.companyname.appname.monthly" ? "/Monthly" : "/Yearly"
            HStack(alignment: .bottom, spacing: 4) {
                Text("\(prodcut.product.priceLocale.currencySymbol ?? "") \(prodcut.product.price)")
                    .font(.title2.bold())
                Text(duration)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.vertical,12)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(duration == "/Monthly" ? Color.red.gradient : Color.black.gradient)
            }
        }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
            .environmentObject(IAPViewModel())
    }
}
