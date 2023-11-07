//
//  ContentView.swift
//  StatusBarUpdate
//
//  Created by Balaji Venkatesh on 03/10/23.
//

import SwiftUI

enum Style: String, CaseIterable {
    case defaults = "Default"
    case light = "Light"
    case dark = "Dark"
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .defaults:
            return .default
        case .light:
            return .lightContent
        case .dark:
            return .darkContent
        }
    }
}

struct ContentView: View {
    @State private var statusBarStyle: Style = .defaults
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $statusBarStyle) {
                    ForEach(Style.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: statusBarStyle, initial: true) { oldValue, newValue in
                    /// Updating Status bar Style
                    UIApplication.shared.setStatusBarStyle(newValue.statusBarStyle)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Status Bar Style")
        }
    }
}

#Preview {
    ContentView()
}
