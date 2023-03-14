import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: permissionService,
  organizationName: organizationName,
  targets: [
    Target(
      name: permissionService,
      platform: .iOS,
      product: .framework,
      bundleId: "\(reverseOrganizationName).\(appName).\(permissionService)",
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
      name: "\(permissionService)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(permissionService)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(permissionService)")
      ]),
    Target(
      name: "\(permissionService)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(permissionService)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(permissionService)")
      ])
  ]
)
