import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: notificationService,
  organizationName: organizationName,
  targets: [
    Target(
      name: notificationService,
      platform: .iOS,
      product: .framework,
      bundleId: "\(reverseOrganizationName).\(appName).\(notificationService)",
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
        .external(name: "Notifications"),
        .external(name: "RandomUIKit")
      ]
    )
  ]
)
