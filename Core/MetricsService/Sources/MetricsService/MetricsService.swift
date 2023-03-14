//
//  MetricsService.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 14.03.2023.
//

import Foundation
import YandexMobileMetrica

public protocol MetricsService {
  
  /// Отправляем стандартную метрику
  ///  - Parameter event: Выбираем метрику
  func track(event: MetricsnEvents)
  
  /// Отправляем метрику и дополнительную информацию в словаре `[String : String]`
  /// - Parameters:
  ///  - event: Выбираем метрику
  ///  - properties: Словарик с дополнительной информацией `[String : String]`
  func track(event: MetricsnEvents, properties: [String: String])
}

public final class MetricsServiceImpl: MetricsService {
  
  public init() {}
  
  // MARK: - Internal func
  
  public func track(event: MetricsnEvents) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  public func track(event: MetricsnEvents, properties: [String: String]) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}
