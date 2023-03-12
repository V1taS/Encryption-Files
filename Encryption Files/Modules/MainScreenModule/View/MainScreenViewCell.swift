//
//  MainScreenViewCell.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit
import RandomUIKit
import Lottie

// MARK: - SmallButtonCell

final class MainScreenViewCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = MainScreenViewCell.description()
  
  // MARK: - Private property
  
  private let customImageView = UIImageView()
  private let plugNoPreviewItemsLottie = LottieAnimationView(name: Appearance().plugNoPreviewItemsLottieImage)
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - data: Изображение
  public func configureCellWith(_ data: (data: Data, name: String, extension: String)) {
    if let image = UIImage(data: data.data) {
      customImageView.image = image
      plugNoPreviewItemsLottie.isHidden = true
      customImageView.isHidden = false
      plugNoPreviewItemsLottie.stop()
    } else {
      plugNoPreviewItemsLottie.isHidden = false
      plugNoPreviewItemsLottie.play()
      customImageView.isHidden = true
    }
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [customImageView, plugNoPreviewItemsLottie].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: 200),
      customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: appearance.insets.left),
      customImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: appearance.insets.top),
      customImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -appearance.insets.right),
      customImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -appearance.insets.bottom),
      
      plugNoPreviewItemsLottie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: appearance.insets.left),
      plugNoPreviewItemsLottie.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: appearance.insets.top),
      plugNoPreviewItemsLottie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: -appearance.insets.right),
      plugNoPreviewItemsLottie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: -appearance.insets.bottom),
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    customImageView.contentMode = .scaleAspectFill
    customImageView.clipsToBounds = true
    customImageView.scalesLargeContentImage = true
    
    plugNoPreviewItemsLottie.isHidden = true
    plugNoPreviewItemsLottie.contentMode = .scaleAspectFit
    plugNoPreviewItemsLottie.loopMode = .loop
    plugNoPreviewItemsLottie.animationSpeed = Appearance().animationSpeed
    plugNoPreviewItemsLottie.clipsToBounds = true
  }
}

// MARK: - Appearance

private extension MainScreenViewCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: .zero, left: .zero, bottom: 8, right: .zero)
    let plugNoPreviewItemsLottieImage = "file_lottie"
    let animationSpeed: CGFloat = 0.5
  }
}
