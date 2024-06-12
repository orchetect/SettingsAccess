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
        
        if #available(macOS 13.0, *) { // MenuBarExtra only available on macOS 13+
            MenuBarExtra {
                MenuBarExtraMenuView()
                // Do not add .openSettingsAccess() here when using a menu-based MenuBarExtra.
                // Instead, use SettingsLink(label:preAction:postAction:) in the menu.
            } label: {
                Text("Demo")
            }
        }
        
        Settings {
            SettingsView()
        }
    }
}

struct MenuBarExtraMenuView: View {
    var body: some View {
        SettingsLink {
            Text("Settings...")
        } preAction: {
            // code to run before Settings opens
            
            // this does nothing if running from Xcode, but running as a standalone app it will work.
            // the reason we want to activate the app is that the native SettingsLink does not bring
            // the Settings window to the front in a dockless menubar app.
            NSApp.activate(ignoringOtherApps: true)
        } postAction: {
            // code to run after Settings opens
        }
        
        Divider()
        
        Button("Quit") {
            NSApp.terminate(nil)
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
