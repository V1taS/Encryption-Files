//
//  ApplicationServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Протокол, описывающий все зависимости системы.
/// Создан для отказа от DI framework в пользу концепции Composition Root.
///
/// Причины отказа от DI:
/// 1. Использовать меньше сторонних зависимостей
/// 2. Уменьшение количества ошибок/крашей приложения, т.к. используется строгая типизация для каждой зависимости
///
/// Прочитать про концепцию можно в [статье](https://blog.ploeh.dk/2011/07/28/CompositionRoot/)
protocol ApplicationServices {
  
  /// Сервис клавиатуры
  var keyboardService: KeyboardService { get }
  
  /// Сервис по работе с уведомлениями
  var notificationService: NotificationService { get }
  
  /// Сервис по работе с разрешениями
  var permissionService: PermissionService { get }
  
  /// Сервис по работе с локальным хранилищем
  var fileManagerService: FileManagerService { get }
  
  /// Сервис виброоткликов
  var hapticService: HapticService { get }
  
  /// Сервис кодирования файлов
  var encryptionService: EncryptionService { get }
  
  /// Сервис по работе с метриками
  var metricsService: MetricsService { get }
}

// MARK: - Реализация ApplicationServices

final class ApplicationServicesImpl: ApplicationServices {
  
  private let encryptionServiceImpl = EncryptionServiceImpl()
  private let permissionServiceImpl = PermissionServiceImpl()
  private let fileManagerImpl = FileManagerImpl()
  
  // MARK: - Internal property
  
  var fileManagerService: FileManagerService {
    fileManagerImpl
  }
  
  var permissionService: PermissionService {
    permissionServiceImpl
  }
  
  var notificationService: NotificationService {
    NotificationServiceImpl()
  }
  
  var keyboardService: KeyboardService {
    KeyboardServiceImpl()
  }
  
  var hapticService: HapticService {
    HapticServiceImpl()
  }
  
  var encryptionService: EncryptionService {
    encryptionServiceImpl
  }
  
  var metricsService: MetricsService {
    MetricsServiceImpl()
  }
}
