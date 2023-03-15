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
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .external(name: "CryptoSwift")
      ]
    )
  ]
)
