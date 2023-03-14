//
//  PermissionServiceAbstraction.swift
//  MainScreenModule
//
//  Created by Vitalii Sosin on 15.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import AppTrackingTransparency

public protocol PermissionServiceAbstraction {
  
  /// Запрос на отслеживание. Доступно с IOS 14
  ///  - Parameter status: Статус ответа пользователя
  @available(iOS 14, *)
  func requestIDFA(_ status: ((ATTrackingManager.AuthorizationStatus) -> Void)?)
  
  /// Запрос доступа к Галерее
  ///  - Parameter granted: Доступ разрешен
  func requestPhotos(_ status: ((_ granted: Bool) -> Void)?)
  
  /// Запрос доступа к Уведомлениям
  ///  - Parameter granted: Доступ разрешен
  func requestNotification(_ granted: @escaping (Bool) -> Void)
  
  /// Получить статус уведомлений
  ///  - Parameter granted: Доступ разрешен
  func getNotification(status: @escaping (UNAuthorizationStatus) -> Void)
}
