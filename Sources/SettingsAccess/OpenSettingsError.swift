//
//  OpenSettingsError.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Error cases thrown by the `openSettings()` environment method.
public enum OpenSettingsError: Error {
    /// Current version of macOS is not considered a legacy platform.
    case unsupportedPlatform
    
    /// Unable to open Settings/Preferences. The expected Obj-C selectors were not found.
    case selectorNotFound
    
    /// The internal `SettingsLink` was not found or was not set up.
    ///
    /// SettingsAccess internally uses a hidden `SettingsLink` that is added to a view hierarchy at the point the `openSettingsView()` view modifier is used.
    /// However, SwiftUI has not set up or is not found.
    ///
    /// This will occur under one of two conditions:
    /// - The `openSettingsView()` view modifier is missing. It was attached to the wrong view hierarchy, or is not attached to an ancestor of the view that is attempting to call `openSettings()`.
    /// - A call to `openSettings()` was made before SwiftUI could construct the view that has `openSettingsView()` attached. A common case where this happens is when calling `openSettings()` asynchronously.
    ///
    /// Also keep in mind that `openSettings()` is not usable within a menu-based MenuBarExtra menu. `openSettingsView()` should not be attached to the menu content. Instead, see ``SettingsLink(label:preAction:postAction:)``.
    case settingsLinkNotConnected
}

#endif
