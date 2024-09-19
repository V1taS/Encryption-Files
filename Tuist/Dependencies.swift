import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(url: "https://github.com/V1taS/FancyUIKit.git",
              requirement: .branch("master")),
      .remote(url: "https://github.com/V1taS/FancyNotifications",
              requirement: .branch("master")),
      .remote(url: "https://github.com/krzyzanowskim/CryptoSwift.git",
              requirement: .branch("main"))
    ],
    productTypes: [
      "FancyUIKit": .framework
    ]
  ),
  platforms: [.iOS]
)
