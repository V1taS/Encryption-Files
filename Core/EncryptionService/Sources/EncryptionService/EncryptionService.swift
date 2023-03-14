//
//  EncryptionService.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import Foundation
import CryptoSwift
import UIKit

public protocol EncryptionService {
  
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

public final class EncryptionServiceImpl: EncryptionService {
  public init() {}
  
  public func encryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                           password: String,
                           completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
    let key = Array(password.utf8).sha256()
    let iv = Array("1234567890123456".utf8)
    
    DispatchQueue.global(qos: .userInteractive).async {
      var encryptedDataArray: [(data: Data, name: String, extension: String)] = []
      filesData.forEach { file in
        let encryptedBytes = try? file.data.encrypt(cipher: AES(key: key, blockMode: CBC(iv: iv)))
        if let encryptedBytes {
          encryptedDataArray.append((encryptedBytes, file.name, file.extension))
        }
      }
      
      DispatchQueue.main.async {
        completion(encryptedDataArray)
      }
    }
  }
  
  public func decryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                           password: String,
                           completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
    let key = Array(password.utf8).sha256()
    let iv = Array("1234567890123456".utf8)
    
    DispatchQueue.global(qos: .userInteractive).async {
      var decryptedDataArray: [(data: Data, name: String, extension: String)] = []
      filesData.forEach { file in
        let decryptedBytes = try? file.data.decrypt(cipher: AES(key: key, blockMode: CBC(iv: iv)))
        if let decryptedBytes {
          decryptedDataArray.append((decryptedBytes, file.name, file.extension))
        }
      }
      
      DispatchQueue.main.async {
        completion(decryptedDataArray)
      }
    }
  }
}
