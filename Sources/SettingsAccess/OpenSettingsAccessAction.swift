//
//  Environment.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

// NOTE: we shouldn't name this `OpenSettingsAction` because that's the name of Apple's private action

/// An action that opens the app's Settings scene.
///
/// Use the ``SwiftUI/EnvironmentValues/openSettings`` environment value to get the instance of this structure for a given `Environment`.
/// Then call the instance to open the Settings scene.
/// You call the instance directly because it defines a ``callAsFunction()`` method that Swift calls when you call the instance.
///
/// In order for `openSettingsLegacy` to operate, the `openSettingsAccess` view modifier must be applied to an ancestor of the view hierarchy.
///
/// Attach the `openSettingsAccess` view modifier to the base view whose subviews needs access to the `openSettingsLegacy` method.
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
/// In any subview where needed, add the environment method declaration.
/// Then the `Settings` scene may be opened programmatically by calling this method.
///
/// ```swift
/// struct ContentView: View {
///     @Environment(\.openSettingsLegacy) private var openSettingsLegacy
///
///     var body: some View {
///         Button("Open Settings") { try? openSettingsLegacy() }
///     }
/// }
/// ```
@MainActor public final class OpenSettingsAccessAction: ObservableObject {
    typealias Closure = @MainActor @Sendable () throws -> Void
    typealias NonThrowingClosure = @MainActor @Sendable () -> Void
    
    // Closure to run when `openSettingsLegacy()` is called.
    // Default to legacy Settings/Preferences window call.
    // This closure will be replaced with the new SettingsLink trigger later.
    private var closure: Closure?
    
    var closureBinding: Binding<NonThrowingClosure?> = .constant(nil)
    
    // Set up a binding that allows us to update the closure property with a new closure later.
    internal init() {
        if #available(macOS 14, *) {
            // closure will be updated by way of binding later
            closureBinding = bindingFactory()
        } else {
            // we don't need the binding since it's only set by the internal SettingsLink.
            // instead, we can just set the closure once to call the legacy method.
            closure = {
                try openSettingsLegacyOS()
            }
        }
    }
    
    @available(macOS 14, *)
    private func bindingFactory() -> Binding<NonThrowingClosure?> {
        Binding(
            // get is never actually used, but it's provided in case.
            get: { [weak self] in
                guard let closure = self?.closure else { return nil }
                return { try? closure() }
            },
            set: { [weak self] newValue in
                if let newValue {
                    self?.closure = newValue
                } else {
                    self?.closure = nil
                }
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
    ///             try? openSettingsLegacy() // Implicitly calls openSettingsLegacy.callAsFunction()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Throws: ``OpenSettingsError``
    public func callAsFunction() throws {
        Task { @MainActor in
            guard let closure else {
                throw OpenSettingsError.settingsLinkNotConnected
            }
            
            do {
                try closure()
            } catch let e as LegacyOpenSettingsError {
                switch e {
                case .selectorNotFound:
                    throw OpenSettingsError.selectorNotFound
                case .unsupportedPlatform:
                    throw OpenSettingsError.unsupportedPlatform
                }
            } catch {
                throw error // rethrow if a different error
            }
        }
    }
}

extension OpenSettingsAccessAction: Sendable { }

#endif
