//
//  iOS18TourApp.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

@main
struct iOS18TourApp: App {
    @State private var fontSize: CodeFontSize = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(fontSize)
        }
    }
}
