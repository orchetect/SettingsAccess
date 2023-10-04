//
//  OpenSettingsInjectionView.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Wires up the `openSettings` environment method for a view hierarchy that allows opening the
    /// app's Settings scene.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// @main struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .openSettingsAccess()
    ///         }
    ///     }
    /// }
    ///
    /// struct ContentView: View {
    ///     @Environment(\.openSettings) var openSettings
    ///
    ///     var body: some View {
    ///         Button("Open Settings") { openSettings() }
    ///     }
    /// }
    /// ```
    public func openSettingsAccess() -> some View {
        OpenSettingsInjectionView(content: self)
    }
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
internal struct OpenSettingsInjectionView<Content: View>: View {
    @Environment(\.openSettings) public var openSettings
    @State private var closure: () -> Bool = {
        openSettingsLegacyOS()
    }
    
    public let content: Content
    
    public var body: some View {
        Group {
            if #available(macOS 14, *) {
                // make a hidden settings link so we can hijack its button action
                content
                    .background {
                        SettingsLink {
                            Rectangle().fill(.clear)
                        }
                        .prePostActionsButtonStyle(performAction: openSettings.closureBinding)
                        .frame(width: 0, height: 0)
                        .opacity(0)
                    }
            } else {
                content
            }
        }
        .environment(\.openSettings, openSettings)
    }
}

#endif
