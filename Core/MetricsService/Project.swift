import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: metricsService,
  organizationName: organizationName,
  targets: [
    Target(
      name: metricsService,
      platform: .iOS,
      product: .framework,
      bundleId: "\(reverseOrganizationName).\(appName).\(metricsService)",
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
        .external(name: "YandexMobileMetrica")
      ]
    )
  ]
)
