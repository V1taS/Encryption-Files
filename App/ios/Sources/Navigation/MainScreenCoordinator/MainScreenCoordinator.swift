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
import YandexMobileMetrica
import Notifications
import FileManagerService
import PermissionService
import EncryptionService
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainScreenCoordinatorInput {
  
  /// Импорт файлов
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
  
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
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url, let imageData = try? Data(contentsOf: url) else {
      return
    }
    let pathExtension = url.pathExtension
    let name = url.deletingPathExtension().lastPathComponent
    let data = (data: imageData, name: name, extension: pathExtension)
    mainScreenModule?.uploadContentsData([data])
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func decryptionError() {
    track(event: .decryptionError)
    showNegativeAlertWith(title: Appearance().somethingWentWrong,
                          glyph: true,
                          timeout: nil,
                          active: {})
  }
  
  func decryptionSuccessful() {
    track(event: .decryptionSuccessful)
  }
  
  func encryptionError() {
    track(event: .encryptionError)
    showNegativeAlertWith(title: Appearance().somethingWentWrong,
                          glyph: true,
                          timeout: nil,
                          active: {})
  }
  
  func encryptionSuccessful() {
    track(event: .encryptionSuccessful)
  }
  
  func requestGalleryError() {
    showNegativeAlertWith(
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
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tempDirectoryURL.appendingPathComponent($0.name).appendingPathExtension($0.extension)
        do {
          try $0.data.write(to: fileURL, options: .atomicWrite)
          listImageDataPath.append(fileURL)
          dispatchGroup.leave()
        } catch {
          self?.showNegativeAlertWith(title: Appearance().somethingWentWrong,
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
      
      let documentPicker = UIDocumentPickerViewController(urls: listImageDataPath, in: .exportToService)
      documentPicker.delegate = self
      documentPicker.modalPresentationStyle = .formSheet
      self.mainScreenModule?.present(documentPicker, animated: true, completion: nil)
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
  func track(event: MetricsnEvents) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
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
  
  func showNegativeAlertWith(title: String,
                             glyph: Bool,
                             timeout: Double?,
                             active: (() -> Void)?) {
    let appearance = Appearance()
    
    Notifications().showAlertWith(
      model: NotificationsModel(
        text: title,
        textColor: .black,
        style: .negative(colorGlyph: .black),
        timeout: timeout ?? appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: active
      )
    )
  }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension MainScreenCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
          let imageData = image.jpegData(compressionQuality: 1.0) else {
      showNegativeAlertWith(title: Appearance().failedLoadImage,
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
              self?.showNegativeAlertWith(title: Appearance().failedLoadImage,
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

// MARK: - MetricsnEvents

private extension MainScreenCoordinator {
  enum MetricsnEvents: String {
    case encryptionSuccessful = "Успешное шифрование"
    case encryptionError = "Ошибка в шифрование"
    case decryptionSuccessful = "Успешное расшифрование"
    case decryptionError = "Ошибка в расшифровании"
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
    
    let timeout: Double = 2
    let throttleDelay: Double = 0.5
    let systemFontSize: CGFloat = 44
  }
}
