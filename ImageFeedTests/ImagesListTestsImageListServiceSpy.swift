//
//  ImageListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 24.11.2023.
//

import ImageFeed
import UIKit

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    
    static let shared = ImagesListServiceSpy()
    private init() {}
    
    var photos: [ImageFeed.Photo] = []
    
    static let DidChangeNotification: Notification.Name = Notification.Name( rawValue: "ImagesListServiceDidChange")
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
    }
    
    func fetchPhotosNextPage() {
        
        NotificationCenter.default.post(name: ImagesListServiceSpy.DidChangeNotification, object: nil)
       
    }
}
