//
//  MainScreenAssembly.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

/// Сборщик `MainScreen`
final class MainScreenAssembly {
  
  /// Собирает модуль `MainScreen`
  /// - Returns: Cобранный модуль `MainScreen`
  func createModule(_ services: ApplicationServices) -> MainScreenModule {
    let interactor = MainScreenInteractor(services)
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
