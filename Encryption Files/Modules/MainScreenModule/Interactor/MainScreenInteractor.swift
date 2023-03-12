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
  
  /// Получена ошибка
  func didReceiveError()
  
  /// Получен доступ к галерее для сохранения фото
  func requestShareGallerySuccess()
  
  /// Получен доступ к галерее
  func requestGalleryActionSheetSuccess()
  
  /// Доступ к галерее не получен
  func requestGalleryError()
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
  /// Запрос доступа к Галерее для сохранения фото
  func requestShareGalleryStatus()
  
  /// Запрос доступа к Галерее через шторку
  func requestGalleryActionSheetStatus()
  
  /// Кнопка зашифровать была нажата
  func encryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String,
                           isArchive: Bool,
                           estimatedSecondsEncrypted: ((Double) -> Void)?,
                           progress: ((Double) -> Void)?)
  
  /// Кнопка расшифровать была нажата
  func decryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String,
                           estimatedSecondsEncrypted: ((Double) -> Void)?,
                           progress: ((Double) -> Void)?)
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: вью
  init(_ services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func encryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String,
                           isArchive: Bool,
                           estimatedSecondsEncrypted: ((Double) -> Void)?,
                           progress: ((Double) -> Void)?) {
    if isArchive {
      services.encryptionService.encryptFiles(
        data,
        password: password,
        estimatedSecondsEncrypted: estimatedSecondsEncrypted
      ) { [weak self] encryptionFiles in
        guard !encryptionFiles.isEmpty else {
          self?.output?.didReceiveError()
          return
        }
        
        self?.services.zipService.zipFiles(encryptionFiles,
                                           progress: progress,
                                           completion: { [weak self] data in
          guard let data else {
            self?.output?.didReceiveError()
            return
          }
          self?.output?.encryptFilesSuccess([data])
        })
      }
    } else {
      services.encryptionService.encryptFiles(
        data,
        password: password,
        estimatedSecondsEncrypted: estimatedSecondsEncrypted
      ) { [weak self] encryptionFiles in
        guard !encryptionFiles.isEmpty else {
          self?.output?.didReceiveError()
          return
        }
        self?.output?.encryptFilesSuccess(encryptionFiles)
      }
    }
  }
  
  func decryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String,
                           estimatedSecondsEncrypted: ((Double) -> Void)?,
                           progress: ((Double) -> Void)?) {
    guard !data.isEmpty else {
      output?.didReceiveError()
      return
    }
    
    let hasZipFiles = data.contains { data in
      data.extension == "zip"
    }
    
    if hasZipFiles {
      let dispatchGroup = DispatchGroup()
      
      data.forEach { _ in
        dispatchGroup.enter()
      }
      var listData: [(data: Data, name: String, extension: String)] = []
      
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        data.forEach {
          self?.services.zipService.unzipFiles(
            data: $0,
            progress: nil) { data in
              listData.append(contentsOf: data)
              dispatchGroup.leave()
            }
        }
      }
      
      dispatchGroup.notify(queue: .global(qos: .userInteractive)) { [weak self] in
        self?.services.encryptionService.decryptFiles(
          listData,
          password: password,
          estimatedSecondsDecrypt: estimatedSecondsEncrypted) { data in
            DispatchQueue.main.async { [weak self] in
              self?.output?.decryptFilesSuccess(data)
            }
          }
      }
    } else {
      services.encryptionService.decryptFiles(
        data,
        password: password,
        estimatedSecondsDecrypt: estimatedSecondsEncrypted,
        completion: { [weak self] data in
          self?.output?.decryptFilesSuccess(data)
        }
      )
    }
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
}

// MARK: - Appearance

private extension MainScreenInteractor {
  struct Appearance {}
}
