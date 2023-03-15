import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: mainScreenModule,
  organizationName: organizationName,
  targets: [
    Target(
      name: mainScreenModule,
      platform: .iOS,
      product: .framework,
      bundleId: "\(reverseOrganizationName).\(appName).\(mainScreenModule)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleLocalizations": .array([
          .string("en"),
          .string("de"),
          .string("es"),
          .string("it"),
          .string("ru")
        ])
      ]),
      sources: [
        "Sources/**"
      ],
      resources: [
        "Resources/**"
      ],
      copyFiles: nil,
      headers: nil,
      entitlements: nil,
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .external(name: "RandomUIKit")
      ]
    ),
    Target(
      name: "\(mainScreenModule)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(mainScreenModule)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(mainScreenModule)")
      ]),
    Target(
      name: "\(mainScreenModule)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(mainScreenModule)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(mainScreenModule)")
      ])
  ]
)
