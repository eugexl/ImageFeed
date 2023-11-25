//
//  AlertPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 23.11.2023.
//

import ImageFeed
import UIKit

final class AlertPresenterSpy: AlertPresenterProtocol {
    
    var wasCalled: Bool = false
    
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction]?, target: UIViewController) {
        
        wasCalled = true
    }
}
