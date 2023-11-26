//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 30.09.2023.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func alert(with error: Error)
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter.shared
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: NamedImages.authWebBackButton), for: .normal)
        return button
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = UIColor(named: ColorNames.ypBlack)
        return progress
    }()
    
    private let webView: WKWebView = {
        
        let webView = WKWebView()
        webView.accessibilityIdentifier = "AuthWebView"
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        webView.navigationDelegate = self
        setUpWebView()
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private func setUpWebView(){
        
        [   webView,
            progressView,
            backButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate(
            [
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backButton.heightAnchor.constraint(equalToConstant: 24.0),
                backButton.widthAnchor.constraint(equalToConstant: 24.0),
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9.0),
                backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
                progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
                progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
        )
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
    }
    
    @objc
    private func backButtonTapped(){
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    func setProgressValue(_ newValue: Float){
        progressView.setProgress(Float(newValue), animated: true)
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func alert(with error: Error){
        
        switch error {
            
        case NetworkError.invalidURL:
            
            DispatchQueue.main.async {
                let alertAction = UIAlertAction(title: "ОК", style: .cancel) { [weak self] _ in
                    
                    guard let self = self else { return }
                    self.delegate?.webViewViewControllerDidCancel(self)
                }
                
                self.alertPresenter.presentAlert(title: "Что-то пошло не так!",
                                                 message: "Не удалось сформировать запрос",
                                                 actions: [alertAction],
                                                 target: self)
            }
            
        default:
            
            return
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            
            // Чистим кэшированные данные, чтоб после Логаута в приложении страница авторизации Unsplash заново запрашивала параметры (эл. адрес / пароль) пользователя.
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { webData in
                webData.forEach { data in
                    WKWebsiteDataStore.default().removeData(ofTypes: data.dataTypes, for: [data], completionHandler: {})
                }
            }
            decisionHandler(.cancel)
        } else {
            
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        
        return nil
    }
}

