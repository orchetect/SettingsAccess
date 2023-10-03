//
//  Environment.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

// Note: we shouldn't name this `OpenSettingsAction` because that's the name of Apple's private action
/// An action that opens the app's Settings scene.
///
/// Use the ``SwiftUI/EnvironmentValues/openSettings`` environment value to get the instance of this structure for a given `Environment`.
/// Then call the instance to open the Settings scene.
/// You call the instance directly because it defines a ``callAsFunction()`` method that Swift calls when you call the instance.
///
/// In order for `openSettings` to operate, the `openSettingsAccess` view modifier must be applied to an ancestor of the view hierarchy.
///
/// Attach the `openSettingsAccess` view modifier to the base view whose subviews needs access to the `openSettings` method.
///
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .openSettingsAccess()
///         }
///
///         Settings { SettingsView() }
///     }
/// }
/// ```
///
/// In any subview where needed, add the environment method declaration. Then the `Settings` scene may be opened programmatically by calling this method.
///
/// ```swift
/// struct ContentView: View {
///     @Environment(\.openSettings) private var openSettings
///
///     var body: some View {
///         Button("Open Settings") { openSettings() }
///     }
/// }
/// ```
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
