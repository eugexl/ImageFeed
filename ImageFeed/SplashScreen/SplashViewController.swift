//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 07.10.2023.
//

import UIKit

class SplashViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage.shared.token != nil {
            
            switchToTabBarController()
        } else {
           
            performSegue(withIdentifier: Segues.showAuthVC, sender: nil)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showAuthVC {
            
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for \(Segues.showAuthVC)")
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid UIApplication Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: VCs.tabBarVC)
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true) { [weak self] in
            
            guard let self = self else { return }
            
            OAuth2Service.shared.fetchAuthToken(code: code) { response in
                
                switch response {
                case .success(let token):
                    OAuth2TokenStorage.shared.token = token
                    self.switchToTabBarController()
                case .failure(let error):
                    print("SplashViewController: GOT ERROR:")
                    print(error)
                }
            }
        }
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController,didAuthenticateWithCode code: String)
}
