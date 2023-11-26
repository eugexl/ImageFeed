//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 19.11.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol? { get set }
    
    func code(from url: URL) -> String?
    func didUpdateProgressValue(_ newValue: Double)
    func viewDidLoad()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    func viewDidLoad() {
        
        do {
            let request = try authHelper.authRequest()
            
            didUpdateProgressValue(0.0)
            
            view?.load(request: request)
            
        } catch {
            
            view?.alert(with: error)
        }
    }
    
    init(authHelper: AuthHelperProtocol) {
        
        self.authHelper = authHelper
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
        let newProgressValue = Float(newValue)
        
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        
        abs(value - 1.0) <= 0.0001
    }
}
