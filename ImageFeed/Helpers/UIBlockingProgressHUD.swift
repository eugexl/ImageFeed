//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 12.10.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
}
