import Foundation
import ProjectDescription

// MARK: - IOS

public let mainIOSScheme = Scheme(
  name: appName,
  shared: true,
  hidden: false,
  buildAction: BuildAction(
    targets: [
      TargetReference.project(path: .relativeToRoot("\(appPath)/\(iosPath)"),
                              target: appName)
    ]
  ),
  testAction: TestAction.targets(
    [
      TestableTarget(target: TargetReference.project(path: .relativeToRoot("\(appPath)/\(iosPath)"),
                                                     target: "\(appName)Tests"))
    ],
    configuration: .debug,
    attachDebugger: true
  ),
  runAction: RunAction.runAction(
    configuration: .debug,
    attachDebugger: true,
    executable: TargetReference.project(path: .relativeToRoot("\(appPath)/\(iosPath)"),
                                        target: appName),
    arguments: Arguments(environment: [
      "OS_ACTIVITY_MODE": "disable"
    ])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)

// MARK: - MacOS

public let mainMacOSScheme = Scheme(
  name: appName,
  shared: true,
  hidden: false,
  buildAction: BuildAction(
    targets: [
      TargetReference.project(path: .relativeToRoot("\(appPath)/\(macOSPath)"),
                              target: appName)
    ]
  ),
  testAction: TestAction.targets(
    [
      TestableTarget(target: TargetReference.project(path: .relativeToRoot("\(appPath)/\(macOSPath)"),
                                                     target: "\(appName)Tests"))
    ],
    configuration: .debug,
    attachDebugger: true
  ),
  runAction: RunAction.runAction(
    configuration: .debug,
    attachDebugger: true,
    executable: TargetReference.project(path: .relativeToRoot("\(appPath)/\(macOSPath)"),
                                        target: appName)
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
