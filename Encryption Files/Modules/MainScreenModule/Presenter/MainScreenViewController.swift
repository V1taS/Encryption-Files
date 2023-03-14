//
//  MainScreenViewController.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainScreenModuleOutput: AnyObject {
  
  /// Кнопка открыть файл была нажата
  func openFileButtonAction()
  
  /// Доступ к галерее не получен
  func requestGalleryError()
  
  /// Доступ к галерее получен
  func requestGalleryActionSheetSuccess()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter data: данные
  func shareButtonAction(_ data: [(data: Data, name: String, extension: String)])
  
  /// Шифровка прошла успешно
  func encryptionSuccessful()
  
  /// Ошибка в шифровании
  func encryptionError()
  
  /// Успешная расшифровка
  func decryptionSuccessful()
  
  /// Расшифровка с ошибкой
  func decryptionError()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainScreenModuleInput {
  
  /// Запрос доступа к Галерее через шторку
  func requestGalleryActionSheetStatus()
  
  /// Загрузить изображение
  /// - Parameter data: Список данных
  func uploadContentsData(_ data: [(data: Data, name: String, extension: String)])
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MainScreenModuleOutput? { get set }
}

/// Готовый модуль `MainScreenModule`
typealias MainScreenModule = UIViewController & MainScreenModuleInput

/// Презентер
final class MainScreenViewController: MainScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let moduleView: MainScreenViewProtocol
  private let factory: MainScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var cacheEncryptionData: [(data: Data, name: String, extension: String)]?
  private var cacheRawData: [(data: Data, name: String, extension: String)]?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: MainScreenViewProtocol,
       interactor: MainScreenInteractorInput,
       factory: MainScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    interactor.requestShareGalleryStatus()
    setupNavBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  // MARK: - Internal func
  
  func requestGalleryActionSheetStatus() {
    interactor.requestGalleryActionSheetStatus()
  }
  
  func uploadContentsData(_ data: [(data: Data, name: String, extension: String)]) {
    cacheRawData = data
    let totalItemsSizeMB = factory.calculateTotalSizeInMegabytesFor(data)
    moduleView.updateItemsWith(data)
    moduleView.updateTotalItemsSizeMB(totalItemsSizeMB)
    setupNavBar()
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func estimatedSecondsActuon() {
    interactor.estimatedSecondsActuon()
  }
  
  func encryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String) {
    interactor.encryptButtonAction(data, password: password)
  }
  
  func decryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String) {
    interactor.decryptButtonAction(data, password: password)
  }
}

// MARK: - MainScreenInteractorOutput

extension MainScreenViewController: MainScreenInteractorOutput {
  func decryptionError() {
    moduleOutput?.decryptionError()
    didReceiveError()
  }
  
  func encryptionError() {
    moduleOutput?.encryptionError()
    didReceiveError()
  }
  
  func didReceiveEstimatedSeconds(_ seconds: Double) {
    moduleView.updateEstimatedSeconds(seconds)
    setupNavBar()
  }
  
  func encryptFilesSuccess(_ data: [(data: Data, name: String, extension: String)]) {
    cacheEncryptionData = data
    moduleOutput?.shareButtonAction(data)
    moduleView.encryptFilesSuccess()
    setupNavBar()
    moduleOutput?.encryptionSuccessful()
  }
  
  func decryptFilesSuccess(_ data: [(data: Data, name: String, extension: String)]) {
    cacheEncryptionData = data
    moduleOutput?.shareButtonAction(data)
    moduleView.encryptFilesSuccess()
    setupNavBar()
    moduleOutput?.decryptionSuccessful()
  }
  
  func requestShareGallerySuccess() {
    guard let cacheEncryptionData else {
      return
    }
    moduleOutput?.shareButtonAction(cacheEncryptionData)
  }
  
  func requestGalleryActionSheetSuccess() {
    moduleOutput?.requestGalleryActionSheetSuccess()
  }
  
  func requestGalleryError() {
    moduleOutput?.requestGalleryError()
  }
}

// MARK: - MainScreenFactoryOutput

extension MainScreenViewController: MainScreenFactoryOutput {}

// MARK: - Private

private extension MainScreenViewController {
  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.title
    
    let clearButton = UIBarButtonItem(image: appearance.clearButtonActionIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(clearButtonAction))
    
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    let openFileButton = UIBarButtonItem(image: appearance.openFileButtonIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(openFileButtonAction))
    
    if let cacheRawData, !cacheRawData.isEmpty {
      clearButton.isEnabled = true
    } else {
      clearButton.isEnabled = false
    }
    
    if let cacheEncryptionData, !cacheEncryptionData.isEmpty {
      shareButton.isEnabled = true
    } else {
      shareButton.isEnabled = false
    }
    
    navigationItem.rightBarButtonItems = [shareButton, openFileButton, clearButton]
  }
  
  @objc
  func shareButtonAction() {
    guard let cacheEncryptionData else {
      return
    }
    moduleOutput?.shareButtonAction(cacheEncryptionData)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func openFileButtonAction() {
    moduleOutput?.openFileButtonAction()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func clearButtonAction() {
    cacheEncryptionData = nil
    cacheRawData = nil
    moduleView.updateItemsWith([])
    moduleView.updateTotalItemsSizeMB("0")
    impactFeedback.impactOccurred()
    moduleView.clearButtonAction()
    setupNavBar()
  }
  
  func didReceiveError() {
    moduleView.updateItemsWith([])
    moduleView.updateTotalItemsSizeMB("0")
    setupNavBar()
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Encryption Files", comment: "")
    let openFileButtonIcon = UIImage(systemName: "plus")
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let clearButtonActionIcon = UIImage(systemName: "trash")
  }
}
