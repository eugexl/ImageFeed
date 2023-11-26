//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//


import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    let authHelper: AuthHelperProtocol = AuthHelper()
    
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
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        webVC.presenter = presenter
        presenter.view = webVC
        
        // When:
        
        presenter.viewDidLoad()
        
        // Then:
        
        XCTAssertTrue(webVC.loadMethodWasCalled)
    }
    
    func testProtressVisibleWhenLessThenOne(){
        
        // Given:
        
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progressTestValue: Float = 0.6
        
        // When:
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progressTestValue)
        
        // Then:
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        
        // Given:
        
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progressTestValue: Float = 1.0
        
        // When:
        
        let shouldHideProgress =  presenter.shouldHideProgress(for: progressTestValue)
        
        // Then:
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        
        // Given:
        
        guard let url = authHelper.authURL() else {
            
            XCTFail("Не удалось получить URL от AuthHelper-а")
            return
        }
        
        // When:
        
        let urlString = url.absoluteString
        
        // Then:
        
        XCTAssertTrue(urlString.contains(UnsplashData.authorizeURLString))
        XCTAssertTrue(urlString.contains(UnsplashData.accessKey))
        XCTAssertTrue(urlString.contains(UnsplashData.redirectURI))
        XCTAssertTrue(urlString.contains(UnsplashData.responseType))
        XCTAssertTrue(urlString.contains(UnsplashData.accessScope))
    }
    
    func testCodeFromURL() {
        
        // Given:
        
        let testCodeValue = "Test Code Value"
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
            urlComponents?.queryItems = [URLQueryItem(name: UnsplashData.responseType, value: testCodeValue)]
        
        guard let url = urlComponents?.url else {
            
            XCTFail("Не удалось сгенерировать URL для теста!")
            return
        }
        
        // When:
        
        let code = authHelper.code(from: url)
        
        // Then:
        
        XCTAssertEqual(code, testCodeValue)
    }
}
