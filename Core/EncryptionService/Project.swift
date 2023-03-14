import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: encryptionService,
  organizationName: organizationName,
  targets: [
    Target(
      name: encryptionService,
      platform: .iOS,
      product: .framework,
      bundleId: "\(reverseOrganizationName).\(appName).\(encryptionService)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: [
        "Sources/**"
      ],
      resources: [],
      copyFiles: nil,
      headers: nil,
      entitlements: nil,
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .external(name: "CryptoSwift")
      ]
    ),
    Target(
      name: "\(encryptionService)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(encryptionService)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(encryptionService)")
      ]),
    Target(
      name: "\(encryptionService)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(encryptionService)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(encryptionService)")
      ])
  ]
)
