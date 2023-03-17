import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(url: "https://github.com/V1taS/RandomUIKit.git",
              requirement: .branch("master")),
      .remote(url: "https://github.com/V1taS/Notifications",
              requirement: .branch("master")),
      .remote(url: "https://github.com/krzyzanowskim/CryptoSwift.git",
              requirement: .branch("main")),
      .remote(url: "https://github.com/yandexmobile/metrica-sdk-ios",
              requirement: .upToNextMajor(from: "4.4.0")),
      .remote(url: "https://github.com/yandexmobile/metrica-push-sdk-ios",
              requirement: .upToNextMajor(from: "1.0.0"))
    ],
    productTypes: [
      "RandomUIKit": .framework
    ]
  ),
  platforms: [.iOS]
)
