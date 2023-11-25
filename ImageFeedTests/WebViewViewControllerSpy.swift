//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadMethodWasCalled: Bool = false
    
    func alert(with error: Error) {
        
    }
    
    func load(request: URLRequest) {
        
        loadMethodWasCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
