#!/bin/bash

CORE_FILES=(
  "ImageViewer/Scenes/Views/Home/Controller/HomeVC.swift"
  "ImageViewer/Scenes/Views/Home/Controller/ProfileVC.swift"
  "ImageViewer/Scenes/Views/Home/Controller/ViewImageVC.swift"
  "ImageViewer/Scenes/Views/Authentication/Controller/AnimatedLaunchVC.swift"
  "ImageViewer/Scenes/Views/Home/ViewModel/HomeViewModel.swift"
  "ImageViewer/AppUtility/Alert/Alert.swift"
  "ImageViewer/AppUtility/AppCoordinator/AppCoordinator.swift"
  "ImageViewer/AppBase/AppDelegate.swift"
  "ImageViewer/AppBase/SceneDelegate.swift"
  "ImageViewer/AppUtility/Managers/NetworkLayerManager.swift"
  "ImageViewer/AppUtility/Managers/CoreDataManager.swift"
  "ImageViewer/ThirdPartyLibrary/NetworkRechability/ReachabilityManager.swift"
)

COMBINED=$(cat "${CORE_FILES[@]}" 2>/dev/null)

CHECK_FILES=(
  # Foundation
  "ImageViewer/AppUtility/Extensions/Foundation/Bundle+Extension.swift"
  "ImageViewer/AppUtility/Extensions/Foundation/CGFloat+Extension.swift"
  "ImageViewer/AppUtility/Extensions/Foundation/Date+Extension.swift"
  "ImageViewer/AppUtility/Extensions/Foundation/String+Extension.swift"
  "ImageViewer/AppUtility/Extensions/Foundation/UserDefaults+Extension.swift"
  # UIKit Extensions
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIAlertViewControllerStyle+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIApplication+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIBarButtonItem+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIButton+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UICollectionView+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIColor+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIContol+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIFont+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIImageView+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UILabel + Exension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UINavigationController+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIScrollView+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIStoryBoard+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UITableView+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UITapGestureRecognizer+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UITextField+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UITextView+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIView+Extension.swift"
  "ImageViewer/AppUtility/Extensions/UIKit-Extension/UIViewController+Extension.swift"
  # FormatStyle
  "ImageViewer/AppUtility/FormatStyle/FormatStyle.swift"
  "ImageViewer/AppUtility/FormatStyle/Nsobject+FormatStyle.swift"
  "ImageViewer/AppUtility/FormatStyle/ThemeStyle.swift"
  "ImageViewer/AppUtility/FormatStyle/UILabel+FormatStyle.swift"
  "ImageViewer/AppUtility/FormatStyle/UIView+FormatStyle.swift"
  # Other
  "ImageViewer/AppUtility/Other/AppCredential.swift"
  "ImageViewer/AppUtility/Other/AppLanguagesEnum.swift"
  "ImageViewer/AppUtility/Other/ScreenSize.swift"
  "ImageViewer/AppUtility/Other/UserDefault.swift"
  "ImageViewer/AppUtility/Other/Vibration.swift"
)

# Gather ALL symbols from each file and check if any appear in core
ALL_SWIFT=$(find ImageViewer -name "*.swift" | grep -v "cleanup\|find_unused\|build")

echo "=== CHECKING USAGE ==="
for f in "${CHECK_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f"
    continue
  fi
  
  # Extract declared names (func, var, class, struct, enum names)
  SYMBOLS=$(grep -oE '(func|var|class|struct|enum|extension|protocol)\s+[A-Za-z_][A-Za-z0-9_]*' "$f" | awk '{print $2}' | sort -u)
  
  FOUND=0
  for sym in $SYMBOLS; do
    # Skip very generic symbols
    [[ "$sym" == "String" || "$sym" == "UIKit" || "$sym" == "UIView" || "$sym" == "UIButton" || "$sym" == "UILabel" || "$sym" == "UIImage" || "$sym" == "UIColor" || "$sym" == "UIFont" || "$sym" == "UITextField" || "$sym" == "UIImageView" || "$sym" == "UITableView" || "$sym" == "UICollectionView" || "$sym" == "UIScrollView" || "$sym" == "UINavigationController" || "$sym" == "UIViewController" || "$sym" == "UITextView" || "$sym" == "UIBarButtonItem" || "$sym" == "UIControl" || "$sym" == "UIApplication" || "$sym" == "UIAlertController" ]] && continue
    
    # Check if used in any core or linked file
    if grep -ql "\b$sym\b" "${CORE_FILES[@]}" 2>/dev/null; then
      FOUND=1
      break
    fi
  done
  
  if [ $FOUND -eq 0 ]; then
    echo "UNUSED: $f"
  else
    echo "USED:   $f"
  fi
done
