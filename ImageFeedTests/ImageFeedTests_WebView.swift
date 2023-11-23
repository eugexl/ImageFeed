//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//


import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidload() {
        
        // Given:
        
        let webVC = WebViewViewController()
        
        let presenter = WebViewPresenterSpy()
        
        webVC.presenter = presenter
        
        // When:
        
        _ = webVC.view
        
        // Then:
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        
        // Given:
        let webVC = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        
        webVC.presenter = presenter
        presenter.view = webVC
        
        // When:
        presenter.viewDidLoad()
        
        // Then:
        XCTAssertTrue(webVC.loadMethodWasCalled)
    }
    
    func testProtressVisibleWhenLessThenOne(){
        
        // Given:
        let authHelperTest = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelperTest)
        let progressTestValue: Float = 0.6
        
        // When:
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progressTestValue)
        
        // Then:
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        
        // Given:
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progressTestValue: Float = 1.0
        
        // When:
        let shouldHideProgress =  presenter.shouldHideProgress(for: progressTestValue)
        
        // Then:
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        
        // Given:
        let config = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: config)
        
        // When:
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        // Then:
        XCTAssertTrue(urlString.contains(config.authURLString))
        XCTAssertTrue(urlString.contains(config.accessKey))
        XCTAssertTrue(urlString.contains(config.redirectURI))
        XCTAssertTrue(urlString.contains(UnsplashData.responseType))
        XCTAssertTrue(urlString.contains(config.accessScrope))
    }
    
    func testCodeFromURL() {
        
        // Given:
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
            urlComponents.queryItems = [URLQueryItem(name: UnsplashData.responseType, value: "Code Value")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        // When:
        let code = authHelper.code(from: url)
        
        // Then:
        XCTAssertEqual(code, "Code Value")
    }
}
