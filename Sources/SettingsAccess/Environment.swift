//
//  Environment.swift
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
private struct OpenSettingsKey: EnvironmentKey {
    static let defaultValue: OpenSettingsAccessAction = .init()
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {
    /// Opens the app's Settings scene. Call this as a method.
    public var openSettings: OpenSettingsAccessAction {
        get { self[OpenSettingsKey.self] }
        set { /* self[OpenSettingsKey.self] = newValue */ } // only allow use of the original default instance
    }
}

// Note: we shouldn't name this `OpenSettingsAction` because that's the name of Apple's private action
/// An action that opens the app's Settings scene.
public class OpenSettingsAccessAction: ObservableObject {
    // Closure to run when `openSettings()` is called.
    // Default to legacy Settings/Preferences window call.
    // This closure will be replaced with the new SettingsLink trigger later.
    @Published
    var closure: () -> Void = {
        openSettingsLegacyOS()
    }
    
    private(set) var closureBinding: Binding<() -> Void> = .constant({ })
    
    // Set up a binding that allows us to update the closure property with a new closure later.
    internal init() {
        closureBinding = Binding(
            get: { [weak self] in
                self?.closure ?? { }
            }, set: {  [weak self] newValue in
                self?.closure = newValue
            }
        )
    }
    
    /// Don’t call this method directly. SwiftUI calls it for you when you call the `OpenSettingsAccessAction` instance that you get from the Environment:
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @Environment(\.openSettings) private var openSettings
    ///
    ///     var body: some View {
    ///         Button("Open Settings") {
    ///             openSettings() // Implicitly calls openSettings.callAsFunction()
    ///         }
    ///     }
    /// }
    public func callAsFunction() {
        closure()
    }
}

#endif
