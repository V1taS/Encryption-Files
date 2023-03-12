//
//  EncryptionService.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import Foundation
import CryptoSwift
import UIKit

protocol EncryptionService {
  
  /// Зашифровать файлы
  /// - Parameters:
  ///  - filesData: Данные для шифровки
  ///  - password: Пароль для шифровки
  ///  - estimatedSecondsEncrypted: Примерное время выполнения
  ///  - completion: Результат шифровки
  func encryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                    password: String,
                    estimatedSecondsEncrypted: ((Double) -> Void)?,
                    completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void)
  
  /// Расшифровать файлы
  /// - Parameters:
  ///  - filesData: Данные для расшифровки
  ///  - password: Пароль для расшифровки
  ///  - estimatedSecondsEncrypted: Примерное время выполнения
  ///  - completion: Результат расшифровки
  func decryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                    password: String,
                    estimatedSecondsDecrypt: ((Double) -> Void)?,
                    completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void)
}

final class EncryptionServiceImpl: EncryptionService {
  
  func decryptImages(_ encryptedDataArray: [Data],
                     password: String,
                     estimatedSecondsDecrypt: ((Double) -> Void)?,
                     completion: @escaping ([UIImage]) -> Void) {
      let password: [UInt8] = Array("\(password)".utf8)
      let salt: [UInt8] = Array("nacllcan".utf8)
      let iv = AES.randomIV(AES.blockSize)

      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
          guard let self = self else {
              DispatchQueue.main.async {
                  completion([])
              }
              return
          }

//          DispatchQueue.main.async {
//              estimatedSecondsDecrypt?(self.calculateEstimatedSecondsTimeFor(encryptedDataArray))
//          }

          guard let key = try? PKCS5.PBKDF2(
              password: password,
              salt: salt,
              iterations: 4096,
              keyLength: 32, /* AES-256 */
              variant: .sha2(.sha256)
          ).calculate(),
                let aes = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) else {
              DispatchQueue.main.async {
                  completion([])
              }
              return
          }
          
          var images: [UIImage] = []
          encryptedDataArray.forEach { encryptedData in
              guard let decryptedBytes = try? aes.decrypt([UInt8](encryptedData)),
                    let decryptedImage = UIImage(data: Data(decryptedBytes)) else {
                  return
              }
              images.append(decryptedImage)
          }
          
          DispatchQueue.main.async {
              completion(images)
          }
      }
  }
  
  func encryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                    password: String,
                    estimatedSecondsEncrypted: ((Double) -> Void)?,
                    completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
    let password: [UInt8] = Array("\(password)".utf8)
    let salt: [UInt8] = Array("nacllcan".utf8)
    let iv = AES.randomIV(AES.blockSize)
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      
      DispatchQueue.main.async {
        estimatedSecondsEncrypted?(self.calculateEstimatedSecondsTimeFor(filesData))
      }
      
      guard let key = try? PKCS5.PBKDF2(
        password: password,
        salt: salt,
        iterations: 4096,
        keyLength: 32, /* AES-256 */
        variant: .sha2(.sha256)
      ).calculate(),
            let aes = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      var encryptedDataArray: [(data: Data, name: String, extension: String)] = []
      filesData.forEach { data in
        guard let encryptedBytes = try? aes.encrypt([UInt8](data.data)) else {
          return
        }
        let encryptedData = Data(encryptedBytes)
        encryptedDataArray.append((encryptedData, data.name, data.extension))
      }

      
      DispatchQueue.main.async {
        completion(encryptedDataArray)
      }
    }
  }
  
  func decryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                    password: String,
                    estimatedSecondsDecrypt: ((Double) -> Void)?,
                    completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
    let password: [UInt8] = Array("\(password)".utf8)
    let salt: [UInt8] = Array("nacllcan".utf8)
    let iv = AES.randomIV(AES.blockSize)
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      
      DispatchQueue.main.async {
        estimatedSecondsDecrypt?(self.calculateEstimatedSecondsTimeFor(filesData))
      }
      
      guard let key = try? PKCS5.PBKDF2(
        password: password,
        salt: salt,
        iterations: 4096,
        keyLength: 32, /* AES-256 */
        variant: .sha2(.sha256)
      ).calculate(),
            let aes = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      
      var decryptedDataArray: [(data: Data, name: String, extension: String)] = []
      filesData.forEach { file in
          guard let decryptedBytes = try? aes.decrypt(file.data.bytes) else {
              return
          }
          let imageData = decryptedBytes.dropLast(AES.blockSize)
          decryptedDataArray.append((Data(imageData), file.name, file.extension))
      }
      
      DispatchQueue.main.async {
        completion(decryptedDataArray)
      }
    }
  }
  
  private func calculateEstimatedSecondsTimeFor(_ filesData: [(data: Data, name: String, extension: String)]) -> Double {
    // Средняя скорость записи данных на жесткий диск: 100 Мбайт/сек
    let bytesPerSecond = 100 * 1024 * 1024
    let averageProcessingTimePerByte = 1.0 / Double(bytesPerSecond)
    let timeSeconds = filesData.reduce(0.0) { result, file in
      let fileSize = UInt64(file.data.count)
      let estimatedTime = Double(fileSize) * averageProcessingTimePerByte
      return result + estimatedTime
    }
    return timeSeconds
  }
}



// Рабочий код, но для текста
/*
 func encryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                   password: String,
                   estimatedSecondsEncrypted: ((Double) -> Void)?,
                   completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
   let password: [UInt8] = Array("\(password)".utf8)
   let salt: [UInt8] = Array("nacllcan".utf8)
   let iv = AES.randomIV(AES.blockSize)
   
   DispatchQueue.global(qos: .userInteractive).async { [weak self] in
     guard let self else {
       DispatchQueue.main.async {
         completion([])
       }
       return
     }
     
     DispatchQueue.main.async {
       estimatedSecondsEncrypted?(self.calculateEstimatedSecondsTimeFor(filesData))
     }
     
     guard let key = try? PKCS5.PBKDF2(
       password: password,
       salt: salt,
       iterations: 4096,
       keyLength: 32, /* AES-256 */
       variant: .sha2(.sha256)
     ).calculate(),
           let aes = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) else {
       DispatchQueue.main.async {
         completion([])
       }
       return
     }
     var encryptedDataArray: [(data: Data, name: String, extension: String)] = []
     filesData.forEach { file in
       let encryptedBytes = try? aes.encrypt(file.data.bytes)
       if let encryptedBytes {
         encryptedDataArray.append((Data(encryptedBytes), file.name, file.extension))
       }
     }
     
     DispatchQueue.main.async {
       completion(encryptedDataArray)
     }
   }
 }
 
 func decryptFiles(_ filesData: [(data: Data, name: String, extension: String)],
                   password: String,
                   estimatedSecondsDecrypt: ((Double) -> Void)?,
                   completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
   let password: [UInt8] = Array("\(password)".utf8)
   let salt: [UInt8] = Array("nacllcan".utf8)
   let iv = AES.randomIV(AES.blockSize)
   
   DispatchQueue.global(qos: .userInteractive).async { [weak self] in
     guard let self else {
       DispatchQueue.main.async {
         completion([])
       }
       return
     }
     
     DispatchQueue.main.async {
       estimatedSecondsDecrypt?(self.calculateEstimatedSecondsTimeFor(filesData))
     }
     
     guard let key = try? PKCS5.PBKDF2(
       password: password,
       salt: salt,
       iterations: 4096,
       keyLength: 32, /* AES-256 */
       variant: .sha2(.sha256)
     ).calculate(),
           let aes = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) else {
       DispatchQueue.main.async {
         completion([])
       }
       return
     }
     
     var decryptedDataArray: [(data: Data, name: String, extension: String)] = []
     filesData.forEach { file in
       if let decryptedBytes = try? aes.decrypt(file.data.bytes) {
         decryptedDataArray.append((Data(decryptedBytes), file.name, file.extension))
       }
     }
     
     DispatchQueue.main.async {
       completion(decryptedDataArray)
     }
   }
 }
 */
