import Foundation
import ProjectDescription

public func getMainInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    // Идентификатор пакета приложения, который состоит из обратного названия организации и имени цели проекта
    "PRODUCT_BUNDLE_IDENTIFIER": .string("\(reverseOrganizationName).$(PRODUCT_NAME)"),
    
    // Задает отображаемое имя приложения в списке приложений на устройстве.
    "DISPLAY_NAME": .string("Encryption Files"),
    
    // Задает минимальную версию iOS, на которой будет работать приложение
    "IPHONEOS_DEPLOYMENT_TARGET": .string("13.0"),
    
    // Указывает на имя исполняемого файла приложения
    "CFBundleExecutable": .string("Encryption"),
    
    // Ширина табуляции в пробелах
    "TAB_WIDTH": .string("2"),
    
    // Ширина отступа в пробелах
    "INDENT_WIDTH": .string("2"),
    
    // Идентификатор разработчика (Team ID)
    "DEVELOPMENT_TEAM": .string("34VDSPZYU9"),
    
    // Поддерживать открытие файлов на месте
    "LSSupportsOpeningDocumentsInPlace": .boolean(true),
    
    // Стиль подписания кода
    "CODE_SIGN_STYLE": .string("Automatic"),
    
    // Идентификатор подписи кода
    "CODE_SIGN_IDENTITY": .string("iPhone Developer"),
    
    // Отключение опции Bitcode
    "ENABLE_BITCODE": .string("NO"),
    
    // Текущая версия проекта
    "CURRENT_PROJECT_VERSION": .string("1"),
    
    // Краткая версия приложения (например, 1.0), которая отображается в магазине App Store.
    "MARKETING_VERSION": .string("1.0"),
    
    /// Внутренний номер сборки (например, 147.0), используется для отслеживания итераций в процессе разработки.
    "CFBundleVersion": .string("1.0"),
    
    // Включение локализации для статического анализа кода
    "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": .string("YES"),
    
    // Включение тестирования приложения
    "ENABLE_TESTABILITY": .string("YES"),
    
    // Допустимые архитектуры для сборки проекта
    "VALID_ARCHS": .string("$(ARCHS)"),
    
    /// Ключ "DTPlatformVersion" указывает на версию платформы, для которой собирается приложение. В данном случае это iOS 16.2.
    "DTPlatformVersion": .string("13.0"),
    
    /// "CFBundleName" - отображаемое имя приложения в App Store и на главном экране устройства.
    "CFBundleName": .string("Encryption Files"),
    
    /// "CFBundleDisplayName" - отображаемое имя приложения в настройках iOS и в центре уведомлений.
    "CFBundleDisplayName": .string("Encryption Files"),
    
    /// Идентификатор приложения
    "CFBundleIdentifier": .string("com.sosinvitalii.Encryption-Files"),
    
    /// Представляет собой краткую версию приложения, которая отображается в магазине App Store
    /// и используется для идентификации версии вашего приложения.
    "CFBundleShortVersionString": .string("1.0"),
    
    /// Ключ "LSApplicationCategoryType" указывает на категорию приложения в App Store.
    "LSApplicationCategoryType": .string("public.app-category.utilities"),
    
    /// Ключ "ITSAppUsesNonExemptEncryption" указывает, использует ли приложение шифрование, которое не подлежит освобождению от обязательной лицензии экспорта.
    "ITSAppUsesNonExemptEncryption": .boolean(false),
    
    /// "UIDeviceFamily" - список идентификаторов устройств, на которых можно запускать приложение (например, 1 для iPhone или 2 для iPad).
    "TARGETED_DEVICE_FAMILY": .string("1,2"),
    
    /// "UIRequiresFullScreen" - флаг, указывающий, что приложение должно запускаться в полноэкранном режиме.
    "UIRequiresFullScreen": .boolean(true),
    
    /// "UILaunchStoryboardName" - имя сториборда, который используется для отображения запуска приложения.
    "UILaunchStoryboardName": .string("LaunchScreen.storyboard"),
    
    /// "UIApplicationSupportsIndirectInputEvents" - флаг, указывающий, поддерживает ли приложение ввод с помощью геймпадов и других устройств ввода, кроме сенсорного экрана.
    "UIApplicationSupportsIndirectInputEvents": .boolean(true),
    
    /// "CFBundlePackageType" - тип пакета приложения (обычно APPL для приложений).
    "CFBundlePackageType": .string("APPL"),
    
    /// "NSCameraUsageDescription" - описание причины запроса на доступ к камере приложением.
    "NSCameraUsageDescription": .string("Please provide access to the Camera"),
    
    /// "NSAccentColorName" - имя цвета для акцентных элементов пользовательского интерфейса в iOS.
    "NSAccentColorName": .string("AccentColor"),
    
    /// "CFBundleInfoDictionaryVersion" - версия формата файла Info.plist.
    "CFBundleInfoDictionaryVersion": .string("6.0"),
    
    /// "NSContactsUsageDescription" - описание причины запроса на доступ к контактам устройства приложением.
    "NSContactsUsageDescription": .string("Provide access to randomly generate contacts"),
    
    /// Ключ "UIRequiredDeviceCapabilities" указывает на аппаратные возможности устройства, которые требуются для запуска приложения.
    "UIRequiredDeviceCapabilities": .array([.string("armv7")]),
    
    /// Ключ "CFBundleSupportedPlatforms" указывает на платформы, на которых можно запустить приложение. В данном случае это симулятор iPhone.
    "CFBundleSupportedPlatforms": .array([.string("iPhoneSimulator")]),
    
    /// Ключ "NSUserTrackingUsageDescription" предоставляет описание причины запроса на доступ к данным отслеживания пользователя.
    "NSUserTrackingUsageDescription": .string("Can you use your activity data? If you allow, Random Pro's ads on websites and other apps will be more relevant."),
    
    /// Ключ "NSPhotoLibraryUsageDescription" предоставляет описание причины запроса на доступ к библиотеке фотографий.
    "NSPhotoLibraryUsageDescription": .string("Please provide access to the Photo Library"),
    
    /// Ключ "DTXcode" указывает на версию Xcode, используемую для сборки приложения.
    "DTXcode": .integer(1420),
    
    /// Ключ "LSRequiresIPhoneOS" указывает, что приложение может быть запущено только на устройствах с операционной системой iOS.
    "LSRequiresIPhoneOS": .boolean(true),
    
    /// Ключ "CFBundleIconsipad" указывает на настройки иконок приложения на iPad.
    "CFBundleIcons~ipad": .dictionary([
      /// Ключ "CFBundlePrimaryIcon" указывает на основную иконку приложения.
      "CFBundlePrimaryIcon": .dictionary([
        /// Ключ "CFBundleIconFiles" указывает на список имен файлов иконок различных размеров.
        "CFBundleIconFiles": .array([.string("AppIcon60x60"), .string("AppIcon76x76")]),
        /// Ключ "CFBundleIconName" указывает на имя основной иконки.
        "CFBundleIconName": .string("AppIcon")
      ])
    ]),
    
    /// Ключ "DTCompiler" указывает на компилятор, используемый для сборки приложения.
    "DTCompiler": .string("com.apple.compilers.llvm.clang.1_0"),
    
    /// Ключ "UIStatusBarStyle" указывает на стиль строки состояния в верхней части экрана (например, светлый или темный текст).
    "UIStatusBarStyle": .string("UIStatusBarStyleLightContent"),
    
    /// Ключ "CFBundleDevelopmentRegion" указывает на языковые настройки приложения по умолчанию.
    "CFBundleDevelopmentRegion": .string("en"),
    
    /// Ключ "DTSDKBuild" указывает на номер сборки SDK (Software Development Kit), используемого для сборки приложения.
    "DTSDKBuild": .string("20C52"),
    
    /// Ключ "DTPlatformBuild" указывает на номер сборки платформы, для которой собирается приложение.
    "DTPlatformBuild": .string("20C52"),
    
    /// Ключ "UIApplicationSceneManifest" определяет настройки сцен, используемых в приложении.
    /// В данном случае указано, что приложение не поддерживает несколько сцен, а для главного окна используется класс SceneDelegate.
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
    
    /// Ключ "DTPlatformName" указывает на платформу, для которой собирается приложение. В данном случае это симулятор iPhone.
    "DTPlatformName": .string("iphonesimulator"),
    
    /// Ключ "DTXcodeBuild" указывает на номер сборки Xcode, используемого для сборки приложения.
    "DTXcodeBuild": .string("14C18"),
    
    /// Ключ "NSPhotoLibraryAddUsageDescription" предоставляет описание причины запроса на доступ к библиотеке фотографий для сохранения в нее новых фотографий.
    "NSPhotoLibraryAddUsageDescription": .string("Please provide access to the Photo Library"),
    
    /// Ключ "UISupportedInterfaceOrientationsipad" указывает на список поддерживаемых ориентаций экрана на iPad.
    "UISupportedInterfaceOrientations~ipad": .array([
      .string("UIInterfaceOrientationPortrait"),
      .string("UIInterfaceOrientationPortraitUpsideDown"),
      .string("UIInterfaceOrientationLandscapeLeft"),
      .string("UIInterfaceOrientationLandscapeRight")
    ]),
    
    /// Ключ "UIStatusBarHidden" указывает, должна ли строка состояния в верхней части экрана скрываться при запуске приложения.
    "UIStatusBarHidden": .boolean(false)
  ])
}
