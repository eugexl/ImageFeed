//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var view: ImageFeed.WebViewViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
}
