//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 26.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: NamedImages.tabBarItemImageList), selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: NamedImages.tabBarItemProfile), selectedImage: nil)
        
        tabBar.tintColor = UIColor(named: ColorNames.ypWhite)
        tabBar.barTintColor = UIColor(named: ColorNames.ypBlack)
        
        self.viewControllers = [
            imagesListViewController,
            profileViewController
        ]
    }
}
