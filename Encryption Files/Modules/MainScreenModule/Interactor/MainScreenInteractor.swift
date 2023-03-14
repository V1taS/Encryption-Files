//
//  MainScreenInteractor.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainScreenInteractorOutput: AnyObject {
  
  /// Файлы успешно зашифрованы
  func encryptFilesSuccess(_ data: [(data: Data, name: String, extension: String)])
  
  /// Файлы успешно расшифрованы
  func decryptFilesSuccess(_ data: [(data: Data, name: String, extension: String)])
  
  /// Ошибка в шифровании
  func encryptionError()
  
  /// Оставшее время
  func didReceiveEstimatedSeconds(_ seconds: Double)
  
  /// Получен доступ к галерее для сохранения фото
  func requestShareGallerySuccess()
  
  /// Получен доступ к галерее
  func requestGalleryActionSheetSuccess()
  
  /// Доступ к галерее не получен
  func requestGalleryError()
  
  /// Расшифровка с ошибкой
  func decryptionError()
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
  /// Запрос доступа к Галерее для сохранения фото
  func requestShareGalleryStatus()
  
  /// Запрос доступа к Галерее через шторку
  func requestGalleryActionSheetStatus()
  
  /// Кнопка зашифровать была нажата
  func encryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String)
  
  /// Кнопка расшифровать была нажата
  func decryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String)
  
  /// Запустить таймер отсчета в обратную сторону
  func estimatedSecondsActuon()
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  private var timer: Timer?
  private var estimatedSeconds: Double = .zero
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: вью
  init(_ services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func estimatedSecondsActuon() {
    estimatedSeconds = .zero
    let timer = Timer(timeInterval: 1,
                      target: self,
                      selector: #selector(startTimer),
                      userInfo: nil,
                      repeats: true)
    self.timer = timer
    RunLoop.current.add(timer, forMode: .common)
  }
  
  func encryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String) {
    services.encryptionService.encryptFiles(
      data,
      password: password
    ) { [weak self] encryptionFiles in
      guard !encryptionFiles.isEmpty else {
        self?.output?.encryptionError()
        self?.stopTimer()
        return
      }
      self?.output?.encryptFilesSuccess(encryptionFiles)
      self?.stopTimer()
    }
  }
  
  func decryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String) {
    guard !data.isEmpty else {
      output?.decryptionError()
      stopTimer()
      return
    }
    
    services.encryptionService.decryptFiles(
      data,
      password: password,
      completion: { [weak self] data in
        self?.output?.decryptFilesSuccess(data)
        self?.stopTimer()
      }
    )
  }
  
  func requestShareGalleryStatus() {
    permissionGallery { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestShareGallerySuccess()
      case false:
        self?.output?.requestGalleryError()
      }
    }
  }
  
  func requestGalleryActionSheetStatus() {
    permissionGallery { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestGalleryActionSheetSuccess()
      case false:
        self?.output?.requestGalleryError()
      }
    }
  }
}

// MARK: - Private

private extension MainScreenInteractor {
  func permissionGallery(completion: @escaping (Bool) -> Void) {
    services.permissionService.requestPhotos { granted in
      completion(granted)
    }
  }
  
  func stopTimer() {
    if timer != nil {
      timer?.invalidate()
      timer = nil
    }
  }
  
  @objc
  func startTimer() {
    estimatedSeconds += 1
    output?.didReceiveEstimatedSeconds(estimatedSeconds)
  }
}

// MARK: - Appearance

private extension MainScreenInteractor {
  struct Appearance {}
}
