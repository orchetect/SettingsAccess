# SettingsAccess

[![Platforms | macOS 11](https://img.shields.io/badge/platforms-macOS%2011-blue.svg?style=flat)](https://developer.apple.com/swift) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2FSettingsAccess%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/SettingsAccess) [![Xcode 15](https://img.shields.io/badge/Xcode-15-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/SettingsAccess/blob/main/LICENSE)

## Xcode 16 Update

> [!NOTE]
>
> Xcode 16 now makes Apple's previously-private [`openSettings`](https://developer.apple.com/documentation/swiftui/environmentvalues/opensettings) environment method public, and back-ports it to macOS 14.
>
> While this is welcome progress, it still is only incremental and the vast majority of SettingsAccess' functionality is still needed in many scenarios.
>
> SettingsAccess 2.0.0 adds support for compiling with Xcode 16 by renaming its `openSettings` method to `openSettingsLegacy`. For projects targeting macOS 14+ you may opt to use the new native `openSettings` method. For projects targeting older versions of macOS, use `openSettingsLegacy`.

## Why

As of macOS 14 Sonoma:

- Apple completely removed the ability to open the SwiftUI Settings scene using legacy `NSApp.sendAction()` method using the `showSettingsWindow:` (macOS 13) or `showPreferencesWindow:` (macOS 12 and earlier) selectors. The only available method of opening the Settings scene (apart from the _App menu → Settings_ menu item) is to use the new [`SettingsLink`](https://developer.apple.com/documentation/swiftui/settingslink) view.

  ![No Dice](Images/no-dice.png)

- This presents two major restrictions:
  1. There is no simple way to detect when the user has clicked this button if additional code is desired to run before or after the opening of the `Settings` scene.
  2. There is **no** way to programmatically open the `Settings` scene. (Update: Xcode 16 adds support but it is still limited.)
  
- These restrictions become problematic in many scenarios. Some examples that are currently impossible without **SettingsAccess**:
  - You are building a window-based `MenuBarExtra` and want to have a button that activates the app, opens `Settings`, and then also dismisses the window.
  - You want to open the `Settings` scene in response to a user action in your application that requires the user manipulate a setting that may be invalid.

## Solution

- **SettingsAccess** provides a SwiftUI environment method called `openSettingsLegacy()` that can be called anywhere in the view hierarchy to programmatically open the `Settings` scene.
- **SettingsAccess** also provides an initializer for `SettingsLink` which provides two closures allowing execution of arbitrary code before and/or after opening the `Settings` scene.
- The library is backwards compatible with macOS 11 Big Sur and later.
- No private API is used, so it is safe for the Mac App Store.

See [Getting Started](#Getting-Started) below for example usage.

## Limitations

- **SettingsAccess** will only work **within a SwiftUI context**. Which means it requires at least one SwiftUI view and for that view to be instanced and its body invoked. Which means it cannot simply be used globally. This is 100% an Apple-imposed limitation because of the internal limitations of `SettingsLink`.
- Due to SwiftUI limitations, `openSettingsLegacy()` is not usable within a `menu`-based `MenuBarExtra`. In that context, the custom `SettingsLink` initializer may be used to run code before/after opening the `Settings` scene.

## Using the Package

### Swift Package Manager (SPM)

Add SettingsAccess as a dependency using Swift Package Manager.

- In an app project or framework, in Xcode:

  Select the menu: **File → Swift Packages → Add Package Dependency...**

  Enter this URL: `https://github.com/orchetect/SettingsAccess`

- In a Swift Package, add it to the Package.swift dependencies:

  ```swift
  .package(url: "https://github.com/orchetect/SettingsAccess", from: "2.1.0")
  ```

## Getting Started

Import the library.

```swift
import SettingsAccess
```

### 1. Open Settings Programmatically

- Attach the `openSettingsAccess` view modifier to the base view whose subviews needs access to the `openSettingsLegacy` method.

   ```swift
   @main
   struct MyApp: App {
       var body: some Scene {
           WindowGroup {
               ContentView()
                   .openSettingsAccess()
           }
           
           Settings { SettingsView() }
       }
   }
   ```

- In any subview where needed, add the environment method declaration. Then the `Settings` scene may be opened programmatically by calling this method.

   ```swift
   struct ContentView: View {
       @Environment(\.openSettingsLegacy) private var openSettingsLegacy
     
       var body: some View {
           Button("Open Settings") { try? openSettingsLegacy() }
       }
   }
   ```

### 2. Use in a MenuBarExtra Menu

If using a menu-based `MenuBarExtra`, do not apply `openSettingsAccess()` to the menu content. `openSettingsLegacy()` cannot be used there due to limitations of SwiftUI.

Instead, use the custom `SettingsLink` initializer to add a Settings menu item capable of running code before and/or after opening the `Settings` scene.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        MenuBarExtra {
            AppMenuView()
                // Do not attach .openSettingsAccess()
        }
        
        Settings { SettingsView() }
    }
}

struct AppMenuView: View {
    var body: some View {
        SettingsLink { 
            Text("Settings...")
        } preAction: {
            // code to run before Settings opens
        } postAction: {
            // code to run after Settings opens
        }
        
        Button("Quit") { NSApp.terminate(nil) }
    }
}
```

### 3. Wire up About Menu Item to Open the A Settings Window Tab

It is possible to replace your app's standard "About" menu item and have it open the Settings window to a specific tab instead. SettingsAccess makes this possible on older versions of macOS prior to the `openSettings()` environment command being available.

Using the custom `SettingsLink` with pre- and post- actions, you are able to set a UserDefaults-stored variable to the about page prior to the Settings window opening.

```swift
@main
struct MyApp: App {
    @AppStorage("selectedSettingsPage") private var selectedSettingsPage: SettingsPage = .general
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                SettingsLink {
                    Text("About...")
                } preAction: {
                    selectedSettingsPage = .about
                } postAction: {
                    // none
                }
            }
        }
        
        Settings { SettingsView() }
    }
}

enum SettingsPage: String {
    case general
    case about
}

struct SettingsView: View {
    @AppStorage("selectedSettingsPage") private var selectedSettingsPage: SettingsPage = .general
    
    var body: some View {
        TabView(selection: $selectedSettingsPage) {
            GeneralView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(SettingsPage.general)
                
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.bubble.fill")
                }
                .tag(SettingsPage.about)
        }
    }
}

```

## Example Code

Try the [Demo](Demo) example project to see the library in action.

## Requirements

Requires Xcode 15.0 or higher to build.

Once compiled, supports macOS 11.0 or higher.

## How It Works (For Nerds)

`SettingsLink` is a view that wraps a standard SwiftUI `Button` and prior to Xcode 16, its action calls a private environment method called `_openSettings`. (As of Xcode 16 this method is now available publicly. See the [Xcode 16 Update](#Xcode-16-Update) section for more information.)

It is worth noting that due to how SwiftUI `Button` works, it is impossible to attach a simultaneous gesture to attempt to detect a button press.

The solution is the use of a custom `Button` style which, when applied directly to `SettingsLink`, allows us to capture the `Button` press action and execute arbitrary code closures before and after the user presses the button. We can also export this method as an environment method called `openSettingsLegacy` that can be used in a backwards-compatible fashion prior to `openSettings` being made public by Apple.

More info and a deep-dive can be found in [this reddit post](https://www.reddit.com/r/SwiftUI/comments/16ibgy3/settingslink_on_macos_14_why_it_sucks_and_how_i/).

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/SettingsAccess/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using SettingsAccess and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/SettingsAccess/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/SettingsAccess/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/SettingsAccess/discussions) first prior to new submitting PRs for features or modifications is encouraged.
