//
//  SettingsLinkButtonStyle.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

// MARK: - Environment Method

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private struct OpenSettingsKey: EnvironmentKey {
    static let defaultValue: () -> Void = { }
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {
    /// Opens the app's Settings scene. Call this as a method.
    public var openSettings: () -> Void {
        get { self[OpenSettingsKey.self] }
        set { self[OpenSettingsKey.self] = newValue }
    }
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Wires up the `openSettings` environment method for a view heirarchy that allows opening the app's Settings scene.
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
    @State private var closure: () -> Void = {
        openSettingsLegacyOS()
    }
    
    public let content: Content
    
    public var body: some View {
        Group {
            if #available(macOS 14, *) {
                // make a hidden settings link so we can hijack it's button action
                ZStack {
#if swift(>=5.9) // prevents compile error in Xcode 14 because SettingsLink is not in its macOS SDK
                    SettingsLink {
                        // Text(verbatim: "")
                        Rectangle().fill(.clear)
                        // EmptyView()
                    }
                    .prePostActionsButtonStyle(performAction: $closure)
                    .frame(width: 0, height: 0)
                    .opacity(0) // TODO: not sure if this is needed or will work
#endif
                    
                    content
                }
            } else {
                content
            }
        }
        .environment(\.openSettings, $closure.wrappedValue)
    }
}

#endif
