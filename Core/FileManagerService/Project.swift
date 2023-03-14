import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: fileManagerService,
  organizationName: organizationName,
  targets: [
    Target(
      name: fileManagerService,
      platform: .iOS,
      product: .framework,
      bundleId: "\(reverseOrganizationName).\(appName).\(fileManagerService)",
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
      dependencies: []
    ),
    Target(
      name: "\(fileManagerService)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(fileManagerService)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(fileManagerService)")
      ]),
    Target(
      name: "\(fileManagerService)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(fileManagerService)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(fileManagerService)")
      ])
  ]
)
