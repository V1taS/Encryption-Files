import Foundation
import ProjectDescription

public func getMainIOSInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    "MARKETING_VERSION": .string("\(marketingVersion)"),
    "CFBundleShortVersionString": .string("\(marketingVersion)"),
    "CFBundleVersion": .string("\(currentProjectVersion)"),
    "CURRENT_PROJECT_VERSION": .string("\(currentProjectVersion)"),
    "PRODUCT_BUNDLE_IDENTIFIER": .string("com.sosinvitalii.Encryption-Files"),
    "DISPLAY_NAME": .string("Encryption"),
    "CFBundleAllowMixedLocalizations": .boolean(true),
    "UISupportsDocumentBrowser": .boolean(true),
    "CFBundleURLTypes": .array([
      .dictionary([
        "CFBundleURLName": .string("com.sosinvitalii.Encryption-Files.URLName"),
        "CFBundleURLSchemes": .array([
          .string("encryption-files")
        ])
      ])
    ]),
    "CFBundleDocumentTypes": .array([
      .dictionary([
        "CFBundleTypeExtensions": .array([
          .string("pdf")
        ]),
        "CFBundleTypeName": .string("PDF Document"),
        "CFBundleTypeRole": .string("Editor"),
        "LSHandlerRank": .string("Owner")
      ]),
      .dictionary([
        "CFBundleTypeExtensions": .array([
          .string("png"),
          .string("jpg"),
          .string("jpeg")
        ]),
        "CFBundleTypeName": .string("Image"),
        "CFBundleTypeRole": .string("Editor"),
        "LSHandlerRank": .string("Owner")
      ]),
      .dictionary([
        "CFBundleTypeExtensions": .array([
          .string("txt")
        ]),
        "CFBundleTypeName": .string("Text"),
        "CFBundleTypeRole": .string("Editor"),
        "LSHandlerRank": .string("Owner")
      ])
    ]),
    "IPHONEOS_DEPLOYMENT_TARGET": .string("13.0"),
    "CFBundleExecutable": .string("Encryption"),
    "TAB_WIDTH": .string("2"),
    "INDENT_WIDTH": .string("2"),
    "DEVELOPMENT_TEAM": .string("34VDSPZYU9"),
    "LSSupportsOpeningDocumentsInPlace": .boolean(true),
    "CFBundleLocalizations": .array([
      .string("en"),
      .string("ru")
    ]),
    "CODE_SIGN_STYLE": .string("Automatic"),
    "CODE_SIGN_IDENTITY": .string("iPhone Developer"),
    "ENABLE_BITCODE": .string("NO"),
    "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": .string("YES"),
    "ENABLE_TESTABILITY": .string("YES"),
    "VALID_ARCHS": .string("arm64"),
    "DTPlatformVersion": .string("13.0"),
    "CFBundleName": .string("Encryption"),
    "CFBundleDisplayName": .string("Encryption"),
    "CFBundleIdentifier": .string("com.sosinvitalii.Encryption-Files"),
    "LSApplicationCategoryType": .string("public.app-category.utilities"),
    "ITSAppUsesNonExemptEncryption": .boolean(false),
    "TARGETED_DEVICE_FAMILY": .string("1,2"),
    "UIRequiresFullScreen": .boolean(true),
    "UILaunchStoryboardName": .string("LaunchScreen.storyboard"),
    "UIApplicationSupportsIndirectInputEvents": .boolean(true),
    "CFBundlePackageType": .string("APPL"),
    "NSCameraUsageDescription": .string("Please provide access to the Camera"),
    "NSAccentColorName": .string("AccentColor"),
    "CFBundleInfoDictionaryVersion": .string("6.0"),
    "NSContactsUsageDescription": .string("Provide access to randomly generate contacts"),
    "NSPhotoLibraryUsageDescription": .string("Please provide access to the Photo Library"),
    "DTXcode": .integer(1420),
    "LSRequiresIPhoneOS": .boolean(true),
    "CFBundleIcons~ipad": .dictionary([
      "CFBundlePrimaryIcon": .dictionary([
        "CFBundleIconFiles": .array([.string("AppIcon60x60"), .string("AppIcon76x76")]),
        "CFBundleIconName": .string("AppIcon")
      ])
    ]),
    "DTCompiler": .string("com.apple.compilers.llvm.clang.1_0"),
    "UIStatusBarStyle": .string("UIStatusBarStyleLightContent"),
    "CFBundleDevelopmentRegion": .string("en"),
    "DTSDKBuild": .string("20C52"),
    "DTPlatformBuild": .string("20C52"),
    "UIApplicationSceneManifest": .dictionary([
      "UIApplicationSupportsMultipleScenes": .boolean(false),
      "UISceneConfigurations": .dictionary([
        "UIWindowSceneSessionRoleApplication": .array([
          .dictionary([
            "UISceneConfigurationName": .string("Default Configuration"),
            "UISceneDelegateClassName": .string("Encryption.SceneDelegate")
          ])
        ])
      ])
    ]),
    "DTPlatformName": .string("iphoneos"),
    "DTXcodeBuild": .string("14C18"),
    "NSPhotoLibraryAddUsageDescription": .string("Please provide access to the Photo Library"),
    "UISupportedInterfaceOrientations~ipad": .array([
      .string("UIInterfaceOrientationPortrait"),
      .string("UIInterfaceOrientationPortraitUpsideDown"),
      .string("UIInterfaceOrientationLandscapeLeft"),
      .string("UIInterfaceOrientationLandscapeRight")
    ]),
    "UIStatusBarHidden": .boolean(false)
  ])
}

public func getMainMacOSInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    "MARKETING_VERSION": .string("\(marketingVersion)"),
    "CFBundleShortVersionString": .string("\(marketingVersion)"),
    "CFBundleVersion": .string("\(currentProjectVersion)"),
    "CURRENT_PROJECT_VERSION": .string("\(currentProjectVersion)"),
    "PRODUCT_BUNDLE_IDENTIFIER": .string("com.sosinvitalii.Encryption-Files.Mac"),
    "CFBundleName": .string("Encryption"),
    "CFBundleDisplayName": .string("Encryption"),
    "CFBundleIdentifier": .string("com.sosinvitalii.Encryption-Files.Mac"),
    "LSApplicationCategoryType": .string("public.app-category.utilities"),
    "NSPrincipalClass": .string("NSApplication"),
    "ITSAppUsesNonExemptEncryption": .boolean(false),
    "CFBundlePackageType": .string("APPL"),
    "NSCameraUsageDescription": .string("Please provide access to the Camera"),
    "NSContactsUsageDescription": .string("Provide access to randomly generate contacts"),
    "NSPhotoLibraryUsageDescription": .string("Please provide access to the Photo Library"),
    "NSPhotoLibraryAddUsageDescription": .string("Please provide access to the Photo Library"),
    "CFBundleInfoDictionaryVersion": .string("6.0"),
    "DTXcode": .integer(1420),
    "DTCompiler": .string("com.apple.compilers.llvm.clang.1_0"),
    "CFBundleDevelopmentRegion": .string("en"),
    "DTSDKBuild": .string("20C52"),
    "DTPlatformBuild": .string("20C52"),
    "DTPlatformName": .string("macos"),
    "DTXcodeBuild": .string("14C18"),
    "NSAccentColorName": .string("AccentColor"),
  ])
}
