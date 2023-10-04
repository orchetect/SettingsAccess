//
//  Utilities.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import AppKit

/// Use old API to open Settings scene on macOS versions prior to macOS 14.
/// This method has no effect on macOS 14 or later.
///
/// - Returns: `true` if platform is `< macOS 14` and if the call to open Settings/Preferences succeeds.
func openSettingsLegacyOS() -> Bool {
    if #available(macOS 14, *) {
        // sendAction methods are deprecated on macOS 14+ and we must use a SettingsLink View
        return false
    }
    
    func trySelector(_ selector: Selector) -> Bool {
        guard NSApp.responds(to: selector) else { return false }
        NSApp.sendAction(selector, to: nil, from: nil)
        return true
    }
    
    // macOS 12
    if trySelector(Selector(("showSettingsWindow:"))) { return true }
    
    // macOS 11 and earlier
    if trySelector(Selector(("showPreferencesWindow:"))) { return true }
    
    return false
}

#endif
