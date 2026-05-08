# Project File Structure and Connections

This README provides a mapping of all files remaining in the `ImageViewer` project and explains how they support the 5 core ViewControllers.

## 🏆 The 5 Core Files
1. **HomeVC**: The primary dashboard displaying the image grid.
2. **AnimatedLaunchVC**: The initial entrance, handling splash animations and Firebase/Google login.
3. **ProfileVC**: Displays user profile details and manages the logout flow.
4. **ViewImageVC**: Detailed viewer for high-resolution images.
5. **HomeViewModel**: The engine behind the Home screen, managing API fetching and CoreData caching.

---

## 🛠 Supporting Infrastructure

### 🚀 App Entry & Navigation
- **AppDelegate.swift** / **SceneDelegate.swift**: Standard iOS entry points.
- **AppCoordinator.swift**: Orchestrates the initial flow (Launch -> Home).

### 🌐 Networking & Data Persistence
- **UnsplashPhotoModel.swift**: The central data object for images.
- **NetworkLayerManager.swift**: Handles native `URLSession` API calls.
- **CoreDataManager.swift**: Manages local database storage for offline mode.
- **AppCredential.swift**: Centralized storage for sensitive API keys.

### 🔔 UI Alerts & Feedback
- **Alert.swift**: Singleton for showing Snackbars and standard Alerts.
- **TTGSnackBar.swift**: Core engine for showing "Offline" and "Success" notifications.
- **ReachabilityManager.swift** / **Reachability.swift**: Monitors connectivity to switch between Online and Offline feeds.

### 🎨 Styling & Theme (Fluent Interface)
These files enable the `.font(...).textColor(...)` chaining syntax used in your ViewControllers.
- **FormatStyle.swift**: Defines the `FormatStyle` protocol.
- **Nsobject+FormatStyle.swift**: Extends labels, buttons, and fields with styling methods.
- **UIView+FormatStyle.swift**: Adds `.cornerRadius()`, `.borderColor()`, and `.shadow()` chaining.
- **ThemeClasses.swift**: Minimal subclasses (`ThemeTextField`, `ThemeBlueButton`) required by the `ProfileVC` storyboard.
- **ScreenSize.swift**: Handles screen-relative geometry for the image grid.

### 🌍 Localization & Text
- **Localization.swift**: Powers the `.localized` property on every string.
- **AppMessages.swift**: The central dictionary for all text strings (`AppMessages` and `AppStrings`).
- **AppLanguagesEnum.swift**: Supports language switching logic.

### 🏗 Utility Extensions (Foundation & UIKit)
- **Bundle+Extension.swift**: App identity (Name, Version, Language).
- **String+Extension.swift**: Data validation (Email, Numbers) and trimming.
- **UserDefaults+Extension.swift**: Simplifies saving user state.
- **UIApplication+Extension.swift**: Finds the top ViewController for global alerts.
- **UIButton+Extension.swift**: Interaction helpers for buttons.
- **UICollectionView+Extension.swift**: Grid layout and direction logic for `HomeVC`.
- **UIColor+Extension.swift**: Theme color palette.
- **UIFont+Extension.swift**: Custom font integration logic.
- **UILabel + Exension.swift**: Label-specific styling utilities.
- **UINavigationController+Extension.swift**: Appearance management for the navigation bar.
- **UIStoryBoard+Extension.swift**: Quick instantiation of ViewControllers.
- **UITableView+Extension.swift**: Scrolling and loading helpers.
- **UITapGestureRecognizer+Extension.swift**: Modern closure-based tap handling.
- **UITextField+Extension.swift**: Input formatting and placeholder localization.
- **UIView+Extension.swift**: Core geometry and design helpers.
- **UIViewController+Extension.swift**: General ViewController utility logic.

---
**Status:** All unlinked and redundant files have been removed. The project is now lean and strictly supports your 5 core files.
