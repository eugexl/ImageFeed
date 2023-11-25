//
//  ImageFeedTests_ProfileViewController.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 23.11.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // Проверяем метод выход из приложения
    func testProfilePresenterLeavingApp(){
        
        // Given:
        
        let sut = ProfilePresenter()
        let oauth2TokenStorageSpy = OAuth2TokenStorageSpy.shared
        sut.oauth2TokenStorage = oauth2TokenStorageSpy
        
        // When:
        
        sut.leaveApp()
        
        // Then:
        
        XCTAssertNil(OAuth2TokenStorageSpy.shared.token)
        
    }
    
}
