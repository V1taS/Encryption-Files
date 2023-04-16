import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  options: .options(),
  packages: [],
  settings: projectBuildIOSSettings,
  targets: [
    Target(
      name: appName,
      platform: .iOS,
      product: .app,
      bundleId: "com.sosinvitalii.Encryption-Files",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: getMainIOSInfoPlist(),
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
        .external(name: "YandexMobileMetrica"),
        .external(name: "YandexMobileMetricaPush"),
        
        // Core
        .project(target: fileManagerService,
                 path: .relativeToRoot("\(corePath)/\(fileManagerService)")),
        .project(target: permissionService,
                 path: .relativeToRoot("\(corePath)/\(permissionService)")),
        .project(target: encryptionService,
                 path: .relativeToRoot("\(corePath)/\(encryptionService)")),
        
        // Features
        .project(target: mainScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(mainScreenModule)"))
      ],
      settings: targetBuildIOSSettings,
      coreDataModels: [],
      environment: [:],
      launchArguments: [],
      additionalFiles: []
    )
  ],
  schemes: [mainIOSScheme],
  fileHeaderTemplate: nil,
  additionalFiles: [],
  resourceSynthesizers: [
    .strings(),
    .assets()
  ]
)
