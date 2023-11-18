//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 30.09.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    var delegate: SplashViewController?
    static private(set) var gotAuthCode: Bool = false
    
    private let enterButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor(named: ColorNames.ypBlack), for: .normal)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(named: ColorNames.ypWhite)
        
        return button
    }()
    
    private let unsplashLogo: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: NamedImages.unsplashLogo))
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    deinit {
        AuthViewController.gotAuthCode = false
    }
    
    private func setUpUI(){
        
        view.backgroundColor = UIColor(named: ColorNames.ypBlack)
        
        [unsplashLogo, enterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        unsplashLogo.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        unsplashLogo.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        unsplashLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 280.0).isActive = true
        unsplashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enterButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        enterButton.widthAnchor.constraint(equalToConstant: 343.0).isActive = true
        enterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 640).isActive = true
        enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        enterButton.addTarget(self, action: #selector(presentWebView), for: .touchUpInside)
    }
    
    @objc
    private func presentWebView (){
        
        let webVC = WebViewViewController()
        webVC.modalPresentationStyle = .fullScreen
        webVC.delegate = self
        
        present(webVC, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate{
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        AuthViewController.gotAuthCode = true
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            delegate?.authViewController(self, didAuthenticateWithCode: code)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        
        dismiss(animated: true)
    }
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController( _ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel( _ vc: WebViewViewController)
}
