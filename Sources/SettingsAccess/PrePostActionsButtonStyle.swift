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
@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PrePostActionsButtonStyle: PrimitiveButtonStyle {
    public let preTapAction: (() -> Void)?
    public let postTapAction: (() -> Void)?
    @Binding public var performAction: () -> Void
    
    /// Initialize with an optional pre-action and post-action. Also optionally supply a binding to
    /// expose a method to programmatically call the button's action.
    ///
    /// - Parameters:
    ///   - preTapAction: Closure to execute before the button's action.
    ///   - postTapAction: Closure to execute after the button's action.
    ///   - performAction: Binding to expose a method to programmatically call the button's action.
    public init(
        preTapAction: (() -> Void)?,
        postTapAction: (() -> Void)?,
        performAction: Binding<(() -> Void)> = .constant { }
    ) {
        self.preTapAction = preTapAction
        self.postTapAction = postTapAction
        self._performAction = performAction
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        // capture the button action
        DispatchQueue.main.async {
            performAction = {
                configuration.trigger()
            }
        }
        
        return configuration.label
            .contentShape(Rectangle())
            .allowsHitTesting(true)
            .onTapGesture {
                preTapAction?()
                configuration.trigger()
                postTapAction?()
            }
    }
}

@available(macOS 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private struct PrePostActionsButtonStyleModifier: ViewModifier {
    let preTapAction: (() -> Void)?
    let postTapAction: (() -> Void)?
    @Binding var performAction: () -> Void
    
    init(
        preTapAction: (() -> Void)?,
        postTapAction: (() -> Void)?,
        performAction: Binding<(() -> Void)> = .constant { }
    ) {
        self.preTapAction = preTapAction
        self.postTapAction = postTapAction
        self._performAction = performAction
    }
    
    func body(content: Content) -> some View {
        content.buttonStyle(
            PrePostActionsButtonStyle(
                preTapAction: preTapAction,
                postTapAction: postTapAction,
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
        preTapAction: (() -> Void)? = nil,
        postTapAction: (() -> Void)? = nil,
        performAction: Binding<(() -> Void)> = .constant { }
    ) -> some View {
        modifier(
            PrePostActionsButtonStyleModifier(
                preTapAction: preTapAction,
                postTapAction: postTapAction,
                performAction: performAction)
        )
    }
}

#endif
