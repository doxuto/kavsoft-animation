//
//  Extensions.swift
//  LauncScreen
//
//  Created by Balaji on 01/07/22.
//

import SwiftUI

extension View{
    // MARK: Safe Area Value
    func safeArea()->UIEdgeInsets{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return .zero}
        guard let safeArea = window.windows.first?.safeAreaInsets else{return .zero}
        
        return safeArea
    }
}
