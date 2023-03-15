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
      scripts: [
        scriptSwiftLint
      ],
      dependencies: []
    )
  ]
)
