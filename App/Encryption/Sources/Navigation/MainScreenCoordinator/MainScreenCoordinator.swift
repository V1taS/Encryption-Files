//
//  MainScreenCoordinator.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit
import MobileCoreServices
import PhotosUI
import MainScreenModule
import MetricsService
import NotificationService
import FileManagerService
import PermissionService
import EncryptionService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: MainScreenCoordinatorOutput? { get set }
}

typealias MainScreenCoordinatorProtocol = MainScreenCoordinatorInput & Coordinator

final class MainScreenCoordinator: NSObject, MainScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: MainScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainScreenModule: MainModuleInput?
  private var anyCoordinator: Coordinator?
  private let window: UIWindow?
  private let metricsService = MetricsServiceImpl()
  private let notificationService = NotificationServiceImpl()
  private let fileManagerService = FileManagerImpl()
  private let permissionService = PermissionServiceImpl()
  private let encryptionService = EncryptionServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - navigationController: UINavigationController
  init(_ window: UIWindow?,
       _ navigationController: UINavigationController) {
    self.window = window
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenModule = MainScreenAssembly().createModule(encryptionService, permissionService)
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    
    checkDarkMode()
    navigationController.pushViewController(mainScreenModule, animated: true)
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func decryptionError() {
    metricsService.track(event: .decryptionError)
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func decryptionSuccessful() {
    metricsService.track(event: .decryptionSuccessful)
  }
  
  func encryptionError() {
    metricsService.track(event: .encryptionError)
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func encryptionSuccessful() {
    metricsService.track(event: .encryptionSuccessful)
  }
  
  func requestGalleryError() {
    notificationService.showNegativeAlertWith(
      title: Appearance().allowAccessToGallery,
      glyph: false,
      timeout: nil,
      active: {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
        }
        UIApplication.shared.open(settingsUrl)
      }
    )
  }
  
  func requestGalleryActionSheetSuccess() {
    openGalleryModule()
  }
  
  func shareButtonAction(_ data: [(data: Data, name: String, extension: String)]) {
    let dispatchGroup = DispatchGroup()
    
    data.forEach { _ in
      dispatchGroup.enter()
    }
    
    var listImageDataPath: [URL] = []
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      
      data.forEach {
        if let imageFilePath = self?.fileManagerService.saveObjectWith(
          fileName: $0.name,
          fileExtension: ".\($0.extension)",
          data: $0.data
        ) {
          listImageDataPath.append(imageFilePath)
          dispatchGroup.leave()
        } else {
          self?.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                          glyph: true,
                                                          timeout: nil,
                                                          active: {})
          dispatchGroup.leave()
        }
      }
    }
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard !listImageDataPath.isEmpty, let self else {
        return
      }
      
      DispatchQueue.main.async {
        let activityViewController = UIActivityViewController(activityItems: listImageDataPath,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.mainScreenModule?.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                        UIActivity.ActivityType.postToFacebook,
                                                        UIActivity.ActivityType.message,
                                                        UIActivity.ActivityType.addToReadingList,
                                                        UIActivity.ActivityType.assignToContact,
                                                        UIActivity.ActivityType.copyToPasteboard,
                                                        UIActivity.ActivityType.markupAsPDF,
                                                        UIActivity.ActivityType.openInIBooks,
                                                        UIActivity.ActivityType.postToFlickr,
                                                        UIActivity.ActivityType.postToTencentWeibo,
                                                        UIActivity.ActivityType.postToTwitter,
                                                        UIActivity.ActivityType.postToVimeo,
                                                        UIActivity.ActivityType.postToWeibo,
                                                        UIActivity.ActivityType.print]
        if UIDevice.current.userInterfaceIdiom == .pad {
          if let popup = activityViewController.popoverPresentationController {
            popup.sourceView = self.mainScreenModule?.view
            popup.sourceRect = CGRect(x: (self.mainScreenModule?.view.frame.size.width ?? .zero) / 2,
                                      y: (self.mainScreenModule?.view.frame.size.height ?? .zero) / 4,
                                      width: .zero,
                                      height: .zero)
          }
        }
        self.mainScreenModule?.present(activityViewController,
                                       animated: true,
                                       completion: nil)
      }
    }
  }
  
  func openFileButtonAction() {
    mainScreenModule?.present(getImageActionSheet(), animated: true)
  }
  
  func checkDarkMode() {
    let isDarkTheme = UserDefaults.standard.bool(forKey: Appearance().isDarkThemeKey)
    guard let window else {
      return
    }
    window.overrideUserInterfaceStyle = isDarkTheme ? .dark : .light
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func getImageActionSheet() -> UIAlertController {
    let appearance = Appearance()
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    alert.addAction(.init(title: appearance.chooseFromFile, style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      self.openDocumentPickerModule()
    }))
    alert.addAction(.init(title: appearance.chooseFromGallery, style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      self.mainScreenModule?.requestGalleryActionSheetStatus()
    }))
    alert.addAction(.init(title: appearance.actionTitleCancel, style: .cancel, handler: { _ in }))
    return alert
  }
  
  func openDocumentPickerModule() {
    let types: [String] = [
      kUTTypeImage as String,
      kUTTypeMovie as String,
      "public.zip-archive",
      kUTTypePlainText as String,
      kUTTypeRTF as String,
      kUTTypePDF as String
    ]
    let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
    documentPicker.delegate = self
    documentPicker.modalPresentationStyle = .formSheet
    documentPicker.allowsMultipleSelection = true
    mainScreenModule?.present(documentPicker, animated: true, completion: nil)
  }
  
  func openGalleryModule() {
    mainScreenModule?.present(getGalleryModule(), animated: true, completion: nil)
  }
  
  func getGalleryModule() -> UIViewController {
    if #available(iOS 14.0, *) {
      var imagePickerControllerConfig = PHPickerConfiguration(photoLibrary: .shared())
      imagePickerControllerConfig.selectionLimit = .zero
      imagePickerControllerConfig.filter = PHPickerFilter.any(of: [.images])
      let imagePickerController = PHPickerViewController(configuration: imagePickerControllerConfig)
      imagePickerController.delegate = self
      return imagePickerController
    } else {
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.allowsEditing = false
      imagePickerController.delegate = self
      return imagePickerController
    }
  }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension MainScreenCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
          let imageData = image.jpegData(compressionQuality: 1.0) else {
      notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
                                                glyph: false,
                                                timeout: nil,
                                                active: {})
      return
    }
    mainScreenModule?.uploadContentsData([(data: imageData, name: "image_\(UUID())", extension: "jpg")])
    picker.dismiss(animated: true)
  }
}

// MARK: - UIDocumentPickerDelegate

extension MainScreenCoordinator: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    var listData: [(data: Data, name: String, extension: String)] = []
    
    urls.forEach { url in
      if let imageData = try? Data(contentsOf: url) {
        let pathExtension = url.pathExtension
        let name = url.deletingPathExtension().lastPathComponent
        listData.append((data: imageData, name: name, extension: pathExtension))
      }
    }
    
    guard !listData.isEmpty else {
      notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
                                                glyph: false,
                                                timeout: nil,
                                                active: {})
      return
    }
    mainScreenModule?.uploadContentsData(listData)
  }
}

// MARK: - PHPickerViewControllerDelegate

extension MainScreenCoordinator: PHPickerViewControllerDelegate {
  @available(iOS 14.0, *)
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    var listData: [(data: Data, name: String, extension: String)] = []
    
    let dispatchGroup = DispatchGroup()
    
    results.forEach { _ in
      dispatchGroup.enter()
    }
    
    DispatchQueue.global().async {
      for item in results {
        item.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.data.identifier) { url, _ in
          guard let fileURL = url, let imageData = try? Data(contentsOf: fileURL) else {
            DispatchQueue.main.async { [weak self] in
              self?.notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
                                                              glyph: false,
                                                              timeout: nil,
                                                              active: {})
            }
            dispatchGroup.leave()
            return
          }
          let pathExtension = fileURL.pathExtension
          let name = fileURL.deletingPathExtension().lastPathComponent
          listData.append((data: imageData, name: name, extension: pathExtension))
          dispatchGroup.leave()
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      self.mainScreenModule?.uploadContentsData(listData)
    }
    picker.dismiss(animated: true)
  }
}

// MARK: - Adapters
extension PermissionServiceImpl: PermissionServiceAbstraction {}
extension EncryptionServiceImpl: EncryptionServiceAbstraction {}

// MARK: - Appearance

private extension MainScreenCoordinator {
  struct Appearance {
    let isDarkThemeKey = "isDarkThemeKey"
    
    let allowAccessToGallery = NSLocalizedString("Разрешить доступ к галерее", comment: "")
    let failedLoadImage = NSLocalizedString("Не удалось загрузить файл", comment: "")
    let failedSomeError = NSLocalizedString("Ошибка", comment: "")
    let chooseFromFile = NSLocalizedString("Файлы", comment: "")
    let chooseFromGallery = NSLocalizedString("Галерея", comment: "")
    let actionTitleCancel = NSLocalizedString("Отмена", comment: "")
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
  }
}
