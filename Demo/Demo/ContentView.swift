//
//  ContentView.swift
//  Demo
//
//  Created by Steffan Andrews on 2023-09-13.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openSettings) private var openSettings
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Open Settings Programmatically") {
                openSettings()
            }
            
            if #available(macOS 14, *) {
                SettingsLink {
                    Text("Open Settings Using SettingsLink")
                }
            }
            
            Text("The settings window may also be accessed from the App -> Settings menu, or with its keyboard shortcut ⌘ ,")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
