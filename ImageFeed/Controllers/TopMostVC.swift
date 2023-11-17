//
//  TopMostVC.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 18.11.2023.
//

import UIKit

struct TopMostVC {
    
    static func getTopMostVC() -> UIViewController? {
        
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow } .first
        
        var topController = window?.rootViewController
        
        while let viewController = topController?.presentedViewController {
            topController = viewController
        }
        
        return topController
    }
}
