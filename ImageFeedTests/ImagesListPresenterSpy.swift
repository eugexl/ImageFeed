//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 22.11.2023.
//

import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    weak var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var presenterViewDidLoadCalled: Bool = false
    
    var photos: [ImageFeed.Photo] = []
    
    func viewDidLoad(with view: ImageFeed.ImagesListViewControllerProtocol) {
        self.view = view
        
        presenterViewDidLoadCalled = true
    }
    
    func largePhotoURL(for row: Int) -> URL? {
        return URL(string: "url")
    }
    
    func numberOfPhotos() -> Int {
        return 0
    }
    
    func photoForRow(at row: Int) -> ImageFeed.Photo {
        
        return photos[row]
    }
    
    func willDisplay(row: Int) {
    }
    
    
}
