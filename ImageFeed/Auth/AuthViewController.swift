//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 30.09.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    var delegate: SplashViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.showWebView {
            
            guard let vc = segue.destination as? WebViewViewController else {
               fatalError("Не удалось подготовить переход на WebViewViewController")
            }
            navigationController?.navigationBar.barStyle = .default
            vc.delegate = self
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate{
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        
        navigationController?.navigationBar.barStyle = .black
        dismiss(animated: true)
    }
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController( _ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel( _ vc: WebViewViewController)
}
