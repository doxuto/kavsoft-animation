//
//  IAPViewModel.swift
//  IAPGlassfy
//
//  Created by Balaji on 10/11/22.
//

import SwiftUI
import Glassfy

class IAPViewModel: ObservableObject {
    @Published var products: [Glassfy.Sku] = []
    // MARK: Error Properties
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    // MARK: User Status
    @AppStorage("premiumUser") var premiumUser: Bool = false
    
    init(){
        fetchProducts()
        checkPurchase()
    }
    
    func fetchProducts(){
        Glassfy.offerings { (offers, err) in
            // MARK: Offerings ID
            if let offering = offers?["premium"] {
                self.products = offering.skus
            }
        }
    }
    
    func purchase(product: Glassfy.Sku){
        isLoading = true
        Glassfy.purchase(sku: product) { (transaction, e) in
            self.isLoading = false
            if let error = e{
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
                return
            }
            // update app status accondingly
            if let permisson = transaction?.permissions["premium"],permisson.isValid {
                print("Purchased Successfully!")
                self.premiumUser = true
            }
        }
    }
    
    func restorePurchase(){
        isLoading = true
        Glassfy.restorePurchases { permissions, err in
            self.isLoading = false
            if let error = err{
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
                return
            }
            
            if let permissions,let permission = permissions["premium"],permission.isValid{
                print("Restored Successfully!")
                self.premiumUser = true
                self.errorMessage = "Purchase Restored Sucessfully!"
                self.showError.toggle()
            }else{
                self.errorMessage = "No Purchase to Restore!"
                self.showError.toggle()
            }
        }
    }
    
    // MARK: Check Whether the User is Cancelled or Expired the Subscription
    func checkPurchase(){
        Glassfy.permissions { permissions, err in
            if let permissions,let permission = permissions["premium"],permission.isValid{
                // MARK: Do Your Action
            }else{
                // I'm Simply Removing Special Access
                self.premiumUser = false
            }
        }
    }
}
