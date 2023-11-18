//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 30.09.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: NamedImages.authWebBackButton), for: .normal)
        return button
    }()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = UIColor(named: ColorNames.ypBlack)
        return progress
    }()
    
    private let webView: WKWebView = {
        
        return WKWebView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, changeHandler: { [weak self] _ , _ in
            guard let self = self else { return }
            self.updateProgress()
        })
        
        progressView.progress = 0.0
        setUpWebView()
    }
    
    private func setUpWebView(){
        
        var urlComponents = URLComponents(string: UnsplashData.authorizeURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: UnsplashData.accessKey),
            URLQueryItem(name: "redirect_uri", value: UnsplashData.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: UnsplashData.accessScope)
        ]
        
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        
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
        
        webView.navigationDelegate = self
        webView.load(request)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backButtonTapped(){
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func updateProgress(){
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
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
        
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
