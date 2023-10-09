//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 30.09.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.barStyle = .black
        
        progressView.progress = 0.0
        setUpWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
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
        
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    private func updateProgress(){
        
        progressView.progress = Float(webView.estimatedProgress)
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
