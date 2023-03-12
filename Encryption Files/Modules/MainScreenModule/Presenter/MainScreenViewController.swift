//
//  MainScreenViewController.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainScreenModuleOutput: AnyObject {
  
  /// Получена ошибка
  func didReceiveError()
  
  /// Кнопка открыть файл была нажата
  func openFileButtonAction()
  
  /// Доступ к галерее не получен
  func requestGalleryError()
  
  /// Доступ к галерее получен
  func requestGalleryActionSheetSuccess()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter data: данные
  func shareButtonAction(_ data: [(data: Data, name: String, extension: String)])
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
  private var cacheData: [(data: Data, name: String, extension: String)]?
  
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
    let totalItemsSizeMB = factory.calculateTotalSizeInMegabytesFor(data)
    moduleView.updateItemsWith(data)
    moduleView.updateTotalItemsSizeMB(totalItemsSizeMB)
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func encryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String,
                           isArchive: Bool,
                           estimatedSecondsEncrypted: ((Double) -> Void)?,
                           progress: ((Double) -> Void)?) {
    interactor.encryptButtonAction(data,
                                   password: password,
                                   isArchive: isArchive,
                                   estimatedSecondsEncrypted: estimatedSecondsEncrypted,
                                   progress: progress)
  }
  
  func decryptButtonAction(_ data: [(data: Data, name: String, extension: String)],
                           password: String,
                           estimatedSecondsEncrypted: ((Double) -> Void)?,
                           progress: ((Double) -> Void)?) {
    interactor.decryptButtonAction(data,
                                   password: password,
                                   estimatedSecondsEncrypted: estimatedSecondsEncrypted,
                                   progress: progress)
  }
}

// MARK: - MainScreenInteractorOutput

extension MainScreenViewController: MainScreenInteractorOutput {
  func encryptFilesSuccess(_ data: [(data: Data, name: String, extension: String)]) {
    cacheData = data
    moduleOutput?.shareButtonAction(data)
  }
  
  func decryptFilesSuccess(_ data: [(data: Data, name: String, extension: String)]) {
    cacheData = data
    moduleOutput?.shareButtonAction(data)
  }
  
  func didReceiveError() {
    moduleOutput?.didReceiveError()
  }
  
  func requestShareGallerySuccess() {
    guard let cacheData else {
      return
    }
    moduleOutput?.shareButtonAction(cacheData)
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
    
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    let openFileButton = UIBarButtonItem(image: appearance.openFileButtonIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(openFileButtonAction))
    
    navigationItem.rightBarButtonItems = [shareButton, openFileButton]
  }
  
  @objc
  func shareButtonAction() {
    guard let cacheData else {
      moduleOutput?.didReceiveError()
      return
    }
    moduleOutput?.shareButtonAction(cacheData)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func openFileButtonAction() {
    moduleOutput?.openFileButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Encryption Files", comment: "")
    let openFileButtonIcon = UIImage(systemName: "plus")
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
  }
}
