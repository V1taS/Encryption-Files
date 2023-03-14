import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  options: .options(),
  packages: [],
  settings: projectBuildSettings,
  targets: [
    Target(
      name: appName,
      platform: .iOS,
      product: .app,
      bundleId: "com.sosinvitalii.Encryption-Files",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: getMainInfoPlist(),
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
        // External
        .external(name: "Notifications"),
        
        // Core
        .project(target: fileManagerService,
                 path: .relativeToRoot("\(corePath)/\(fileManagerService)")),
        .project(target: metricsService,
                 path: .relativeToRoot("\(corePath)/\(metricsService)")),
        .project(target: permissionService,
                 path: .relativeToRoot("\(corePath)/\(permissionService)")),
        .project(target: notificationService,
                 path: .relativeToRoot("\(corePath)/\(notificationService)")),
        .project(target: encryptionService,
                 path: .relativeToRoot("\(corePath)/\(encryptionService)")),
        
        // Features
        .project(target: mainScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(mainScreenModule)"))
      ],
      settings: targetBuildSettings,
      coreDataModels: [],
      environment: [:],
      launchArguments: [],
      additionalFiles: []
    ),
    Target(
      name: "\(appName)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(appName)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(appName)")
      ]),
    Target(
      name: "\(appName)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(appName)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(appName)")
      ])
  ],
  schemes: [],
  fileHeaderTemplate: nil,
  additionalFiles: [],
  resourceSynthesizers: [
    .strings(),
    .assets()
  ]
)
