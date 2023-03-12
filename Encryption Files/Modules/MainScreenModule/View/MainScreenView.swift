//
//  MainScreenView.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit
import RandomUIKit
import Lottie

/// События которые отправляем из View в Presenter
protocol MainScreenViewOutput: AnyObject {
  
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

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput {
  
  /// Обновить список файлов
  func updateItemsWith(_ data: [(data: Data, name: String, extension: String)])
  
  /// Обновить общий размер файлов
  func updateTotalItemsSizeMB(_ size: String)
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties
  
  private let passwordLabel = UILabel()
  private let passwordTextField = TextFieldView()

  private let inArchiveEncryptionLabel = UILabel()
  private let inArchiveEncryptionSwitch = UISwitch()
  
  private let countItemsLabel = UILabel()
  private let totalItemsSizeMBLabel = UILabel()
  private let estimatedSecondsLabel = UILabel()
  private let progressView = UIProgressView()
  
  private var plugEmptyItemsLottie = LottieAnimationView(name: Appearance().plugEmptyItemsLottieImage)
  private var decryptLottie = LottieAnimationView(name: Appearance().encryptLottieImage)
  
  private let encryptButton = ButtonView()
  private let decryptButton = ButtonView()
  private let stackButtons = UIStackView()
  
  private let tableView = TableView()
  
  private var items: [(data: Data, name: String, extension: String)] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateItemsWith(_ data: [(data: Data, name: String, extension: String)]) {
    decryptLottie.stop()
    decryptLottie.isHidden = true
    
    countItemsLabel.text = "\(Appearance().countItemsTitle): \(data.count)"
    items = data
    tableView.reloadData()
    
    if data.isEmpty {
      plugEmptyItemsLottie.isHidden = false
      plugEmptyItemsLottie.play()
      tableView.isHidden = true
    } else {
      plugEmptyItemsLottie.isHidden = true
      plugEmptyItemsLottie.stop()
      tableView.isHidden = false
    }
  }
  
  func updateTotalItemsSizeMB(_ size: String) {
    totalItemsSizeMBLabel.text = "\(Appearance().totalItemsSizeMBTitle): \(size) Mb"
  }
  
  func startProgress() {
    // TODO: -
  }
  
  func stopProgress() {
    // TODO: -
  }
}

// MARK: - Private

private extension MainScreenView {
  func configureLayout() {
    [encryptButton, decryptButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      stackButtons.addArrangedSubview($0)
    }
    
    [passwordLabel, passwordTextField, inArchiveEncryptionLabel,
     inArchiveEncryptionSwitch, countItemsLabel, totalItemsSizeMBLabel,
     estimatedSecondsLabel, progressView, tableView, stackButtons,
     plugEmptyItemsLottie, decryptLottie].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      passwordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
      passwordLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 4),
      passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      inArchiveEncryptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      inArchiveEncryptionLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
      inArchiveEncryptionSwitch.centerYAnchor.constraint(equalTo: inArchiveEncryptionLabel.centerYAnchor),
      inArchiveEncryptionSwitch.leadingAnchor.constraint(equalTo: inArchiveEncryptionLabel.trailingAnchor, constant: 16),
      inArchiveEncryptionSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      countItemsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      countItemsLabel.topAnchor.constraint(equalTo: inArchiveEncryptionLabel.bottomAnchor, constant: 16),
      countItemsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      totalItemsSizeMBLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      totalItemsSizeMBLabel.topAnchor.constraint(equalTo: countItemsLabel.bottomAnchor, constant: 4),
      totalItemsSizeMBLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      estimatedSecondsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      estimatedSecondsLabel.topAnchor.constraint(equalTo: totalItemsSizeMBLabel.bottomAnchor, constant: 4),
      estimatedSecondsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      progressView.topAnchor.constraint(equalTo: estimatedSecondsLabel.bottomAnchor, constant: 4),
      progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      plugEmptyItemsLottie.leadingAnchor.constraint(equalTo: leadingAnchor),
      plugEmptyItemsLottie.topAnchor.constraint(greaterThanOrEqualTo: progressView.bottomAnchor),
      plugEmptyItemsLottie.trailingAnchor.constraint(equalTo: trailingAnchor),
      plugEmptyItemsLottie.bottomAnchor.constraint(equalTo: stackButtons.topAnchor),
      plugEmptyItemsLottie.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
      
      decryptLottie.leadingAnchor.constraint(equalTo: leadingAnchor),
      decryptLottie.topAnchor.constraint(greaterThanOrEqualTo: progressView.bottomAnchor,
                                         constant: 16),
      decryptLottie.trailingAnchor.constraint(equalTo: trailingAnchor),
      decryptLottie.bottomAnchor.constraint(equalTo: stackButtons.topAnchor),
      decryptLottie.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
      
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      stackButtons.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      stackButtons.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
      stackButtons.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    tableView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = appearance.estimatedRowHeight
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    
    plugEmptyItemsLottie.isHidden = false
    plugEmptyItemsLottie.contentMode = .scaleAspectFit
    plugEmptyItemsLottie.loopMode = .loop
    plugEmptyItemsLottie.animationSpeed = Appearance().animationSpeed
    plugEmptyItemsLottie.clipsToBounds = true
    plugEmptyItemsLottie.play()
    
    decryptLottie.isHidden = true
    decryptLottie.contentMode = .scaleAspectFit
    decryptLottie.loopMode = .loop
    decryptLottie.animationSpeed = Appearance().animationSpeed
    decryptLottie.clipsToBounds = true
    
    tableView.register(MainScreenViewCell.self,
                       forCellReuseIdentifier: MainScreenViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.showsVerticalScrollIndicator = false
    
    passwordLabel.text = appearance.passwordTitle
    inArchiveEncryptionLabel.text = "\(appearance.inArchiveEncryptionTitle)?"
    countItemsLabel.text = "\(appearance.countItemsTitle): 0"
    totalItemsSizeMBLabel.text = "\(appearance.totalItemsSizeMBTitle): 0 Mb"
    estimatedSecondsLabel.text = "\(appearance.estimatedSecondsTitle): 0 \(appearance.secondsTitle)"
    
    stackButtons.axis = .horizontal
    stackButtons.distribution = .fillEqually
    stackButtons.spacing = 16
    
    encryptButton.setTitle(appearance.encryptButtonTitle, for: .normal)
    encryptButton.gradientBackground = [
      RandomColor.only.primaryRed,
      RandomColor.only.primaryPink
    ]
    decryptButton.setTitle(appearance.decryptButtonTitle, for: .normal)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
    
    encryptButton.addTarget(self, action: #selector(encryptButtonAction), for: .touchUpInside)
    decryptButton.addTarget(self, action: #selector(decryptButtonAction), for: .touchUpInside)
  }
  
  @objc
  func encryptButtonAction() {
    let appearance = Appearance()
    output?.encryptButtonAction(items,
                                password: passwordTextField.text ?? "4j6HqL!)3F",
                                isArchive: inArchiveEncryptionSwitch.isOn,
                                estimatedSecondsEncrypted: { [weak self] seconds in
      self?.estimatedSecondsLabel.text = "\(appearance.estimatedSecondsTitle): \(seconds) \(appearance.secondsTitle)"
    },
                                progress: { [weak self] progress in
      DispatchQueue.main.async {
        self?.progressView.setProgress(Float(progress), animated: true)
      }
    })
    
    decryptLottie.isHidden = false
    decryptLottie.play()
    
    plugEmptyItemsLottie.isHidden = true
    plugEmptyItemsLottie.stop()
    tableView.isHidden = true
  }
  
  @objc
  func decryptButtonAction() {
    let appearance = Appearance()
    output?.decryptButtonAction(items,
                                password: passwordTextField.text ?? "4j6HqL!)3F",
                                estimatedSecondsEncrypted: { [weak self] seconds in
      self?.estimatedSecondsLabel.text = "\(appearance.estimatedSecondsTitle): \(seconds) \(appearance.secondsTitle)"
    },
                                progress: { [weak self] progress in
      DispatchQueue.main.async {
        self?.progressView.setProgress(Float(progress), animated: true)
      }
    })
    
    decryptLottie.isHidden = false
    decryptLottie.play()
    
    plugEmptyItemsLottie.isHidden = true
    plugEmptyItemsLottie.stop()
    tableView.isHidden = true
  }
}

// MARK: - UITableViewDelegate

extension MainScreenView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension MainScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = items[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: MainScreenViewCell.reuseIdentifier
    ) as? MainScreenViewCell else {
      assertionFailure("Не получилось прокастить ячейку")
      return UITableViewCell()
    }
    cell.configureCellWith(model)
    return cell
  }
}

// MARK: - Appearance

private extension MainScreenView {
  struct Appearance {
    let estimatedRowHeight: CGFloat = 400
    let plugEmptyItemsLottieImage = "empty_lottie"
    let encryptLottieImage = "cell_lottie"
    let animationSpeed: CGFloat = 0.5
    
    let passwordTitle = NSLocalizedString("Введите пароль для шифрования", comment: "")
    let inArchiveEncryptionTitle = NSLocalizedString("Добавлять файлы в архив", comment: "")
    let countItemsTitle = NSLocalizedString("Выбрано файлов", comment: "")
    let estimatedSecondsTitle = NSLocalizedString("Осталось примерно", comment: "")
    let secondsTitle = NSLocalizedString("секунд", comment: "")
    let encryptButtonTitle = NSLocalizedString("Зашифровать", comment: "")
    let decryptButtonTitle = NSLocalizedString("Расшифровать", comment: "")
    let totalItemsSizeMBTitle = NSLocalizedString("Общий размер файлов", comment: "")
  }
}
