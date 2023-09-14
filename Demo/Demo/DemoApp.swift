//
//  DemoApp.swift
//  Demo
//
//  Created by Steffan Andrews on 2023-09-13.
//

import SwiftUI
import SettingsAccess

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .openSettingsAccess()
        }
        
        Settings {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings window.")
                .frame(idealWidth: 400, maxWidth: .infinity, 
                       idealHeight: 200, maxHeight: .infinity)
        }
        .padding()
    }
}
