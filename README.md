# Wall Gallery - iOS App

---

## 📱 About the App

Wall Gallery is an iOS application that allows users to browse, view, and manage high-quality images. The app integrates with the Unsplash API to fetch photos and supports user authentication via Google Sign-In and Firebase.

---

## ✨ Features

- Browse high-quality images from Unsplash
- User authentication with Google Sign-In
- Firebase Auth integration
- Smooth animated launch screen
- Full-screen image viewing

---

## 🏗 Architecture

> ### ⚠️ Important Note to Reviewer:
> **This project is built using a Customised MVVM (Model-View-ViewModel) Architecture.**
> **This structure has been personally designed and consistently used by across my iOS projects.**

```
ImageViewer/
├── Scenes/
│   ├── Models/               # Data models (User, Photo, List, Home)
│   ├── Views/                # Storyboards & View Controllers
│   │   ├── Authentication/   # Login & Signup screens
│   │   ├── Home/             # Main image browsing screens
│   │   └── LaunchScreen/     # Animated splash screen
│   └── ViewModels/           # Business logic layer
├── AppUtility/               # Extensions, constants, session manager
├── ThirdPartyLibrary/        # Manually added libraries
├── Resources/                # Assets, fonts, colors
└── Plist/                    # Info.plist
```

---

## 🛠 Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 14.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| CocoaPods | 1.12+ |
| macOS (to build) | Ventura 13+ |

---

## ⚙️ Installation & Setup

### Step 1 — Clone the Repository
```bash
git clone https://github.com/kingdsk/Wall-Gallery.git
cd Wall-Gallery
```

### Step 2 — Install Dependencies
```bash
pod install
```

### Step 3 — Open the Workspace
```bash
open ImageViewer.xcworkspace
```
> ⚠️ Always open `.xcworkspace` and NOT `.xcodeproj` after running pod install.

### Step 4 — Configure Signing
- Go to project target → **Signing & Capabilities**
- Select your **Team** and update **Bundle Identifier** if needed

### Step 5 — Run the App
- Select a Simulator or connected device
- Press `Cmd + R`

---

## 📦 Third-Party Libraries (via CocoaPods)

| Library | Purpose |
|---------|---------|
| `SDWebImage` | Async image loading and caching |
| `FirebaseAuth` | User authentication via Firebase |
| `Firebase/Core` | Firebase core configuration |
| `GoogleSignIn` | Google OAuth Sign-In integration |

> Run `pod install` to install all dependencies before building.

---

## 👤 Author

**Divyesh**
GitHub: [@kingdsk](https://github.com/kingdsk)

---

## 📄 License

This project is submitted for evaluation purposes only.
