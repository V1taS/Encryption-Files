import Foundation
import ProjectDescription

public func getMainInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    "PRODUCT_BUNDLE_IDENTIFIER": .string("com.sosinvitalii.Encryption-Files"),
    "DISPLAY_NAME": .string("Encryption Files"),
    "IPHONEOS_DEPLOYMENT_TARGET": .string("13.0"),
    "CFBundleExecutable": .string("Encryption"),
    "TAB_WIDTH": .string("2"),
    "INDENT_WIDTH": .string("2"),
    "DEVELOPMENT_TEAM": .string("34VDSPZYU9"),
    "LSSupportsOpeningDocumentsInPlace": .boolean(true),
    "CODE_SIGN_STYLE": .string("Automatic"),
    "CODE_SIGN_IDENTITY": .string("iPhone Developer"),
    "ENABLE_BITCODE": .string("NO"),
    "CURRENT_PROJECT_VERSION": .string("1"),
    "MARKETING_VERSION": .string("1.0"),
    "CFBundleVersion": .string("1.0"),
    "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": .string("YES"),
    "ENABLE_TESTABILITY": .string("YES"),
    "VALID_ARCHS": .string("arm64"),
    "DTPlatformVersion": .string("13.0"),
    "CFBundleName": .string("Encryption Files"),
    "CFBundleDisplayName": .string("Encryption Files"),
    "CFBundleIdentifier": .string("com.sosinvitalii.Encryption-Files"),
    "CFBundleShortVersionString": .string("1.0"),
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
    "NSUserTrackingUsageDescription": .string("Can you use your activity data? If you allow, Random Pro's ads on websites and other apps will be more relevant."),
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
            "UISceneDelegateClassName": .string("SceneDelegate")
          ])
        ])
      ])
    ]),
    "DTPlatformName": .string("iphonesimulator"),
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
