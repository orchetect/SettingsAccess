//
//  SettingsLink.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

/// Create a `SettingsLink` that optionally executes code before or after the Settings scene is opened.
/// This is suitable for use in a menu, a menu-based `MenuBarExtra`, or any standard `View` where a button
/// is needed. This is also backwards-compatible to macOS 11.
///
/// - Parameters:
///   - label: A view to use as the label for this settings link.
///   - preAction: Closure to execute before the button's action.
///   - postAction: Closure to execute after the button's action.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@ViewBuilder
public func SettingsLink<Label: View>(
    @ViewBuilder label: () -> Label,
    preAction: @escaping () -> Void,
    postAction: @escaping () -> Void
) -> some View {
    if #available(macOS 14.0, *) {
        SettingsLink(label: label)
            .prePostActionsButtonStyle(
                preAction: preAction,
                postAction: postAction
            )
    } else {
        Button(
            action: {
                preAction()
                try? openSettingsLegacyOS() // fail silently
                postAction()
            },
            label: label
        )
    }
}

#endif
