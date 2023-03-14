//
//  EncryptionServiceAbstraction.swift
//  MainScreenModule
//
//  Created by Vitalii Sosin on 15.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public protocol EncryptionServiceAbstraction {
  
  /// Зашифровать файлы
  /// - Parameters:
  ///  - filesData: Данные для шифровки
  ///  - password: Пароль для шифровки
  ///  - completion: Результат шифровки
  func encryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                    password: String,
                    completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void)
  
  /// Расшифровать файлы
  /// - Parameters:
  ///  - filesData: Данные для расшифровки
  ///  - password: Пароль для расшифровки
  ///  - completion: Результат расшифровки
  func decryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                    password: String,
                    completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void)
}
