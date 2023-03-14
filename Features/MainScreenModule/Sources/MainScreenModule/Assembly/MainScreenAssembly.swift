//
//  MainScreenAssembly.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

/// Сборщик `MainScreen`
public final class MainScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `MainScreen`
  /// - Returns: Cобранный модуль `MainScreen`
  public func createModule(_ encryptionService: EncryptionServiceAbstraction,
                           _ permissionService: PermissionServiceAbstraction) -> MainModuleInput {
    let interactor = MainScreenInteractor(encryptionService, permissionService)
    let view = MainScreenView()
    let factory = MainScreenFactory()
    let presenter = MainScreenViewController(moduleView: view,
                                             interactor: interactor,
                                             factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
