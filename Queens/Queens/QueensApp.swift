//
//  QueensApp.swift
//  Queens
//
//  Created by Peter Rutherford on 2026-03-23.
//

import SwiftUI

@main
struct QueensApp: App {
    
    // Appearance modifiers to color, shade and positioning the app's Navigation Bar
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(Color.headerColor)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.2)
        appearance.titleTextAttributes = [.foregroundColor : UIColor.headerTitleColor]
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.headerTitleColor,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .preferredColorScheme(.light)
        }
    }
}
