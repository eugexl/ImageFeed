//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 07.10.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let splashScreenLogo: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: NamedImages.splashScreenLogoImage))
        
        return imageView
    }()
    
    private var token: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage.shared.token != nil {
            fetchProfile()
        } else {
            guard AuthViewController.gotAuthCode == false else { return }
            authoriseUser()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    private func authoriseUser(){
        
        let authVC = AuthViewController()
        authVC.modalPresentationStyle = .fullScreen
        authVC.delegate = self
        present(authVC, animated: true, completion: nil)
    }
    
    private func setUpUI(){
        
        view.backgroundColor = UIColor(named: "YP Black")
        view.addSubview(splashScreenLogo)
        
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid UIApplication Configuration")
        }
        
        let tabBarController = TabBarController()
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        
        dismiss(animated: true) { [weak self] in
            
            guard let self = self else { return }
            
            UIBlockingProgressHUD.show()
            
            OAuth2Service.shared.fetchAuthToken(code: code) { response in
                
                switch response {
                case .success(let token):
                    
                    OAuth2TokenStorage.shared.token = token
                    self.fetchProfile()
                    
                case .failure( _ ):
                    
                    UIBlockingProgressHUD.dismiss()
                    
                    let alertActions = [
                        UIAlertAction(title: "ОК", style: .cancel) { _ in self.authoriseUser() }
                    ]
                    AlertPresenter.shared.presentAlert(
                        title: "Что-то пошло не так!",
                        message: "Не удалось войти в систему.",
                        actions: alertActions,
                        target: self
                    )
                }
            }
        }
    }
    
    private func fetchProfile() {
        
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile() { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let username):
                
                ProfileImageService.shared.fetchProfileImageURL(of: username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
                
            case .failure( _ ):
                
                let alertActions = [
                    UIAlertAction(title: "ОК", style: .cancel) { _ in self.fetchProfile() }
                ]
                
                AlertPresenter.shared.presentAlert(
                    title: "Что-то пошло не так!",
                    message: "Не удалось получить данные с сервера.",
                    actions: alertActions,
                    target: self
                )
                
                UIBlockingProgressHUD.dismiss()
                
                break
            }
        }
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController,didAuthenticateWithCode code: String)
}
