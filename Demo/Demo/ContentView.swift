//
//  ContentView.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SettingsAccess
import SwiftUI

struct ContentView: View {
    // NOTE: As of Xcode 16, Apple has made their previously-private `openSettings` method public.
    // NOTE: This only works when compiling with Xcode 16+ and only supports macOS 14+.
    // @Environment(\.openSettings) private var openSettings

    // OTHERWISE: If your app needs to support macOS 13 or older, use SettingsAccess' legacy method:
    @Environment(\.openSettingsLegacy) private var openSettingsLegacy

    var body: some View {
        VStack(spacing: 20) {
            Button("Open Settings Programmatically") {
                do { try openSettingsLegacy() } catch { print(error) }
            }

            if #available(macOS 14, *) {
                SettingsLink {
                    Text("Open Settings Using Native SettingsLink")
                }
            }

            Text("The settings window may also be accessed from the App -> Settings menu, or with its keyboard shortcut ⌘ ,")
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(minWidth: 500, minHeight: 250)
    }
}
