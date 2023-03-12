//
//  ZipService.swift
//  Encryption Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import Foundation
import Zip

protocol ZipService {
  
  /// Архивация файла
  /// - Parameters:
  ///  - data: Данные для архивации
  ///  - progress: Прогресс выполнения
  ///  - completion: Возвращает результат архивации
  func zipFiles(_ data: [(data: Data, name: String, extension: String)],
                progress: ((Double) -> Void)?,
                completion: @escaping ((data: Data, name: String, extension: String)?) -> Void)
  
  /// Разархивация файла
  /// - Parameters:
  ///  - data: Данные для разархивации
  ///  - progress: Прогресс выполнения
  ///  - completion: Возвращает результат разархивации
  func unzipFiles(data: (data: Data, name: String, extension: String),
                  progress: ((Double) -> Void)?,
                  completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void)
}

final class ZipServiceImpl: ZipService {
  
  private let fileManager = FileManagerImpl()
  
  func zipFiles(_ data: [(data: Data, name: String, extension: String)],
                progress: ((Double) -> Void)?,
                completion: @escaping ((data: Data, name: String, extension: String)?) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self else {
        return
      }
      let dataPathsArray: [URL] = data.compactMap { file in
        let path = self.fileManager.saveObjectWith(fileName: file.name,
                                                   fileExtension: file.extension,
                                                   data: file.data)
        return path
      }
      
      guard let zipFilePath = try? Zip.quickZipFiles(dataPathsArray,
                                                     fileName: "archive",
                                                     progress: progress) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      let data = self.fileManager.readObjectWith(fileURL: zipFilePath)
      self.fileManager.deleteObjectWith(fileURL: zipFilePath, isRemoved: {_ in })
      DispatchQueue.main.async {
        completion((data ?? Data(), "archive", "zip"))
      }
    }
  }
  
  func unzipFiles(data: (data: Data, name: String, extension: String),
                  progress: ((Double) -> Void)?,
                  completion: @escaping ([(data: Data, name: String, extension: String)]) -> Void) {
    guard let saveDataPath = fileManager.saveObjectWith(fileName: data.name,
                                                        fileExtension: ".\(data.extension)",
                                                        data: data.data) else {
      completion([])
      return
    }
    DispatchQueue.global(qos: .userInteractive).async { [ weak self] in
      let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                               isDirectory: true).appendingPathComponent(UUID().uuidString,
                                                                         isDirectory: true)
      try? Zip.unzipFile(saveDataPath,
                         destination: destinationURL,
                         overwrite: true,
                         password: nil,
                         progress: progress)
      let fileURLs = try? FileManager.default.contentsOfDirectory(at: destinationURL,
                                                                  includingPropertiesForKeys: nil,
                                                                  options: .skipsHiddenFiles)
      var dataArray: [(data: Data, name: String, extension: String)] = []
      fileURLs?.forEach { url in
        if let data = try? Data(contentsOf: url) {
          let pathExtension = url.pathExtension
          let name = url.deletingPathExtension().lastPathComponent
          dataArray.append((data, name, pathExtension))
        }
      }
      self?.fileManager.deleteObjectWith(fileURL: saveDataPath, isRemoved: { _ in })
      DispatchQueue.main.async {
        completion(dataArray)
      }
    }
  }
}
