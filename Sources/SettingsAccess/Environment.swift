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
@MainActor private struct OpenSettingsKey: @preconcurrency EnvironmentKey {
    static let defaultValue = OpenSettingsAccessAction()
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {
    /// Opens the app's Settings scene. Call this as a method.
    @_disfavoredOverload
    public var openSettingsLegacy: OpenSettingsAccessAction {
        get { self[OpenSettingsKey.self] }
        set { /* self[OpenSettingsKey.self] = newValue */ } // only allow use of the original default instance
    }
}

#endif
