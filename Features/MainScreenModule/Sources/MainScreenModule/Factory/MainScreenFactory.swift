//
//  MainScreenFactory.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  
  /// Получаем общий размер всех файлов в мегабайтах
  func calculateTotalSizeInMegabytesFor(_ data: [(data: Data, name: String, extension: String)]) -> String
}

/// Фабрика
final class MainScreenFactory: MainScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func calculateTotalSizeInMegabytesFor(_ data: [(data: Data, name: String, extension: String)]) -> String {
    // Считаем общий размер всех файлов в байтах
    let totalSizeInBytes = data.reduce(0, { $0 + $1.data.count })

    // Конвертируем размер в мегабайты
    let totalSizeInMegabytes = Double(totalSizeInBytes) / (1024 * 1024)

    // Форматируем результат с округлением до одной цифры после запятой
    let formattedSize = String(format: "%.1f", totalSizeInMegabytes)
    return formattedSize
  }
}

// MARK: - Appearance

private extension MainScreenFactory {
  struct Appearance {}
}
