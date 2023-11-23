//
//  ImageFeedTests_ImagesList.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 22.11.2023.
//


import XCTest
@testable import ImageFeed

final class ImagesListTests_ImageList: XCTestCase {
    
    let mockPhotos = [
        Photo(
            id: "01",
            size: CGSize(width: 0, height: 0),
            createdAt: Date(),
            welcomeDescription: "",
            thumbImageURL: "https://",
            largeImageURL: "https://",
            isLiked: true ),
        Photo(
            id: "02",
            size: CGSize(width: 0, height: 0),
            createdAt: Date(),
            welcomeDescription: "",
            thumbImageURL: "https://",
            largeImageURL: "https://",
            isLiked: false)
        ]
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // Проверяем, что Контроллер обновляет список фотографий через метод updateList
    func testImageListViewUpdatesList(){
        
        // Given: Testing updateList method
        
        let sut = ImagesListViewController()
        
        let mockIndexPaths = [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 1, section: 0),
        ]
        
        let initialPhotosNumber = sut.photos.count
        
        // When:  Pass photo, table info to updateList method
        
        sut.updateList(with: mockPhotos, at: mockIndexPaths)
        
        sleep(2)
        
        // Then: Count new number of photos in array
        
        let finalPhotosNumber = sut.photos.count
        
        XCTAssertLessThan(initialPhotosNumber, finalPhotosNumber)
        
    }
    
    // Проверяем что при вызове метода likeWarn вызывается Alert Presenter
    
    func testImageListViewWarnsOfLike() {
        
        // Given:
        let sut = ImagesListViewController()
        let alertPresenterSpy = AlertPresenterSpy()
        sut.alertPresenter = alertPresenterSpy
        
        // When:
        
        sut.likeWarn()
        
        // Then:
        
        XCTAssertTrue(alertPresenterSpy.wasCalled)
        
    }
    
    // Проверяем корректное выполнение Презентером метода viewDidLoad, а так же обновление фотографик в методе willDisplay
    func testImageListPresenterViewDidLoadAndWillDisplay(){
        
        // Given:
        let imageListVC = ImagesListViewController()
        var sut = imageListVC.presenter
        sut.imagesListService = ImagesListServiceSpy.shared
        
        sut.imagesListService.photos = mockPhotos
        
        // When:
        
        sut.viewDidLoad(with: imageListVC)
        
        // Then:
        
        // Свойству view присвоилось значение ImagesListViewController-а
        XCTAssertTrue(sut.view === imageListVC)
        
        // ImagesListPresenter обновил список фотографий у ViewController-а
        XCTAssertGreaterThan(imageListVC.photos.count, 0)
        
    }
}
