//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 06.11.2023.
//

import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    
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
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                
                var newPhotos: [Photo] = []
                
                photoResult.forEach { photoResult in
                    
                    newPhotos.append(self.convertResult2Photo(from: photoResult))
                }
                
                photos.append(contentsOf: newPhotos)
                lastLoadedPage += 1
                
                NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                
            case .failure:
                
                if let topController = TopMostVC.getTopMostVC() {
                    
                    let alertActionCancel = UIAlertAction(title: "ОК", style: .cancel)
                    
                    let alertActionTryAgain = UIAlertAction(title: "Попробовать ещё раз", style: .default) { _ in
                        ImagesListService.shared.fetchPhotosNextPage()
                    }
                    AlertPresenter.shared.presentAlert(
                        title: "Что-то пошло не так!",
                        message: "Не удалось загрузить изображения",
                        actions: [alertActionTryAgain, alertActionCancel],
                        target: topController
                    )
                }
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard task == nil else {
            return
        }
        
        assert(Thread.isMainThread)
        
        let request = URLRequests.shared.photoLike(photoId: photoId, isLike: isLike)
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<AbbreviatedPhoto, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let abbreviatedPhoto):
                
                let photo = self.convertResult2Photo(from: abbreviatedPhoto.photo)
                
                self.photos = self.photos.map { $0.id == photoId ? photo : $0 }
                completion(.success(()))
                
            case.failure(let error):
                
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func convertResult2Photo(from photoResult: PhotoResult) -> Photo {
        
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        let createdAt = DateFormatters.iso8601DateFormatter.date(from: photoResult.createdAt ?? "")
        
        return Photo(
            id: photoResult.id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: photoResult.welcomeDescription,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.isLiked
        )
    }
}
