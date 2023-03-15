//
//  String+Localized.swift
//  MainScreenModule
//
//  Created by Vitalii Sosin on 15.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

extension String {
  func localized() -> String {
    let frameworkBundle = Bundle(for: MainScreenViewController.self)
    return NSLocalizedString(self,
                             tableName: nil,
                             bundle: frameworkBundle,
                             value: "",
                             comment: self)
  }
}
