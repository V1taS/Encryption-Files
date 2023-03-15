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
      scripts: [
        scriptSwiftLint
      ],
      dependencies: []
    )
  ]
)
