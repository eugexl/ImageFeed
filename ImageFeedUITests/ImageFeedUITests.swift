//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Eugene Dmitrichenko on 22.11.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    private let userEmail = ""
    private let userPass = ""
    private let userFullName = ""
    private let userName = ""
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    
    func testAuthView() throws {
        
        print("TestAuth")
        
        app.buttons["AuthButton"].tap()
        
        let webView = app.webViews["AuthWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 7))
        
        let loginField = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(loginField.waitForExistence(timeout: 5))
        
        loginField.tap()
        loginField.typeText(userEmail)
        
        webView.swipeUp()
        
        sleep(2)
        
        let passwdField = webView.descendants(matching: .secureTextField).element
        
        XCTAssertTrue(passwdField.waitForExistence(timeout: 5))
        
        passwdField.tap()
        passwdField.typeText(userPass)
        
        webView.swipeUp()
        
        sleep(2)
        
        webView.buttons["Login"].tap()
    }
    
    func testFeedView() throws {
        
        let imagesTable = app.tables.firstMatch
        
        let cell = imagesTable.children(matching: .cell).element(boundBy: 0)
        
        cell.swipeUp()
        
        sleep(3)
        
        let activeCell = imagesTable.children(matching: .cell).element(boundBy: 1)
        
        let likeButton = activeCell.buttons["LikeButton"]
        
        print("Un-/Liking photo")
        
        likeButton.tap()
        
        sleep(3)
        
        likeButton.tap()
        
        sleep(3)
        
        print("Open image in ScrollView ...")
        
        activeCell.tap()
        
        sleep(6)
        
        let image = app.scrollViews.images.firstMatch
        
        print("Scaling image ...")
        
        image.pinch(withScale: 4, velocity: 1)
        
        sleep(4)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        print("Going back ...")
        sleep(3)
        
        let backButton = app.buttons["BackButton"]
        
        backButton.tap()
        
        sleep(2)
    }
    
    func testProfileView() throws {
    
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(4)
        
        XCTAssertTrue(app.staticTexts[userFullName].exists)
        XCTAssertTrue(app.staticTexts[userName].exists)
        
        app.buttons["ExitButton"].tap()
        
        sleep(4)
        
        app.alerts.firstMatch.buttons.element(boundBy: 0)
    }
}
