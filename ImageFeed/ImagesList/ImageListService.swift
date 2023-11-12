//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 06.11.2023.
//

import Foundation

final class ImageListService {
    
    static let shared = ImageListService()
    
    static let DidChangeNotification = Notification.Name( rawValue: NotificationNames.imagesListServiceDidChange)
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int = 0
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        
        guard task == nil else {
            return
        }
        
        assert(Thread.isMainThread)
        
        let nextPage = lastLoadedPage + 1
        
        let request = URLRequests.shared.photoListRequest(page: nextPage)
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[Photo], Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photoList):
                
                photos.append(contentsOf: photoList)
                lastLoadedPage += 1
                
                NotificationCenter.default.post(name: ImageListService.DidChangeNotification, object: nil)
                
            case .failure(let error):
                
                print("ImageListService.fetchPhotosNextPage, got error: ")
                print(error)
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
