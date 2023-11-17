//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 14.11.2023.
//

import UIKit

final class AlertPresenter {
    
    static let shared = AlertPresenter()
    
    private init() {}
    
    /// Функция для отображения Уведомления
    /// - Parameters:
    ///     - title: Заголовок уведомления.
    ///     - message: Сообщение уведомления
    ///     - actions: Действия (кнопки), предлагаемые в уведомлении
    ///     - target: UIViewController на котором будет отображено уведомление
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction]?, target: UIViewController) {
        
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        
        actions?.forEach {
            alert.addAction($0)
        }
        
        target.present(alert, animated: true)
    }
}
