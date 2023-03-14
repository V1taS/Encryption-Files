//
//  MetricsService.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 14.03.2023.
//

import Foundation
import YandexMobileMetrica

protocol MetricsService {
  
  /// Отправляем стандартную метрику
  ///  - Parameter event: Выбираем метрику
  func track(event: MetricsnEvents)
  
  /// Отправляем метрику и дополнительную информацию в словаре `[String : String]`
  /// - Parameters:
  ///  - event: Выбираем метрику
  ///  - properties: Словарик с дополнительной информацией `[String : String]`
  func track(event: MetricsnEvents, properties: [String: String])
}

final class MetricsServiceImpl: MetricsService {
  
  // MARK: - Internal func
  
  func track(event: MetricsnEvents) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsnEvents, properties: [String: String]) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}
