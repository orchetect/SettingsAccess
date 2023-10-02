//
//  PrePostActionsButtonStyle.swift
//  SettingsAccess • https://github.com/orchetect/SettingsAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

/// Allows execution of code before and/or after user clicks a button.
/// Also provides a binding to a method which can programmatically call the button's action.
///
/// > Note that this will not work when applied to a `Button` or `SettingsLink` contained
/// > within a menu or menu-based MenuBarExtra.
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PrePostActionsButtonStyle: PrimitiveButtonStyle {
    public let preAction: (() -> Void)?
    public let postAction: (() -> Void)?
    @Binding public var performAction: () -> Void
    
    /// Initialize with an optional pre-action and post-action. Also optionally supply a binding to
    /// expose a method to programmatically call the button's action.
    ///
    /// - Parameters:
    ///   - preAction: Closure to execute before the button's action.
    ///   - postAction: Closure to execute after the button's action.
    ///   - performAction: Binding to expose a method to programmatically call the button's action.
    public init(
        preAction: (() -> Void)?,
        postAction: (() -> Void)?,
        performAction: Binding<(() -> Void)> = .constant { }
    ) {
        self.preAction = preAction
        self.postAction = postAction
        self._performAction = performAction
    }
    
    // note: this never gets called when used in a menu instead of a View
    public func makeBody(configuration: Configuration) -> some View {
        // capture the button action
        DispatchQueue.main.async {
            performAction = {
                configuration.trigger()
            }
        }
        
        if #available(macOS 12.0, *) { // role is macOS 12+
            return Button(role: configuration.role) {
                preAction?()
                configuration.trigger()
                postAction?()
            } label: {
                configuration.label
            }
        } else {
            return Button {
                preAction?()
                configuration.trigger()
                postAction?()
            } label: {
                configuration.label
            }
        }
    }
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private struct PrePostActionsButtonStyleModifier: ViewModifier {
    let preAction: (() -> Void)?
    let postAction: (() -> Void)?
    @Binding var performAction: () -> Void
    
    init(
        preAction: (() -> Void)?,
        postAction: (() -> Void)?,
        performAction: Binding<(() -> Void)> = .constant { }
    ) {
        self.preAction = preAction
        self.postAction = postAction
        self._performAction = performAction
    }
    
    func body(content: Content) -> some View {
        content.buttonStyle(
            PrePostActionsButtonStyle(
                preAction: preAction,
                postAction: postAction,
                performAction: $performAction
            )
        )
    }
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Convenience to apply ``PrePostActionsButtonStyle``.
    /// Allows execution of code before and/or after user clicks a button.
    /// Also provides a binding to a method which can programmatically call the button's action.
    public func prePostActionsButtonStyle(
        preAction: (() -> Void)? = nil,
        postAction: (() -> Void)? = nil,
        performAction: Binding<(() -> Void)> = .constant { }
    ) -> some View {
        modifier(
            PrePostActionsButtonStyleModifier(
                preAction: preAction,
                postAction: postAction,
                performAction: performAction)
        )
    }
}

#endif
