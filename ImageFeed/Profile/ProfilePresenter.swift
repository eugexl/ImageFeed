//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//

import UIKit

protocol ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad(with view: ProfileViewControllerProtocol)
    func leaveApp()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad(with view: ProfileViewControllerProtocol){
        
        self.view = view
        
        if let profile = ProfileService.shared.profile {
            
            self.view?.fillUpElements(with: profile)
        }
        
        updateAvatar()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            
            self?.updateAvatar()
        })
    }
    
    func leaveApp() {
        
        // Зачишаем cookie
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        // Удаляем токен доступа к API
        OAuth2TokenStorage.shared.clearToken()
        
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid UIApplication Configuration")
        }
        
        let splashViewontroller = SplashViewController()
        
        window.rootViewController = splashViewontroller
    }
    
    func updateAvatar(){
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setAvatar(with: url)
    }
}
