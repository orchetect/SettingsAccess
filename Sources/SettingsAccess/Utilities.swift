//
//  Utilities.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import AppKit

/// Use old API to open Settings scene (or standard app Preferences window) on macOS versions prior to macOS 14.
/// This method has no effect on macOS 14 or later and will always throw an error.
///
/// - Throws: `LegacyOpenSettingsError`
@MainActor func openSettingsLegacyOS() throws {
    if #available(macOS 14, *) {
        // sendAction methods are deprecated on macOS 14+ and we must use a SettingsLink View instead
        throw LegacyOpenSettingsError.unsupportedPlatform
    }
    
    func trySelector(_ selector: Selector) -> Bool {
        guard NSApp.delegate?.responds(to: selector) == true else { return false }
        NSApp.sendAction(selector, to: NSApp.delegate, from: nil)
        return true
    }
    
    // macOS 12
    if trySelector(Selector(("showSettingsWindow:"))) { return }
    
    // macOS 11 and earlier
    if trySelector(Selector(("showPreferencesWindow:"))) { return }
    
    throw LegacyOpenSettingsError.selectorNotFound
}

#endif
