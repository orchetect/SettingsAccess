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
func openSettingsLegacyOS() {
    if #available(macOS 14, *) {
        // sendAction methods are deprecated; must use SettingsLink View
        // this should never happen but we'll throw an assert just in case
        assertionFailure("openSettingsLegacyOS() was called on macOS 14 or later. This shouldn't happen. Please file a SettingsAccess bug report.")
    } else if #available(macOS 13, *) {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    } else {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
}

#endif
