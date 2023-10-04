//
//  LegacyOpenSettingsError.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

enum LegacyOpenSettingsError: Error {
    /// Current version of macOS is not considered a legacy platform.
    case unsupportedPlatform
    
    /// Unable to open Settings/Preferences. The expected Obj-C selectors were not found.
    case selectorNotFound
}

#endif
