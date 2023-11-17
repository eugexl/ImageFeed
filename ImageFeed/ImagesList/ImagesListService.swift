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
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[Photo], Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let photoList):
                
                photos.append(contentsOf: photoList)
                lastLoadedPage += 1
                
                NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                
            case .failure:
                
                if let topController = TopMostVC.getTopMostVC() {
                    
                    let alertActionCancel = UIAlertAction(title: "ОК", style: .cancel)
                
                    let alertActionTryAgain = UIAlertAction(title: "Попробовать ещё раз", style: .default) { _ in
                        ImagesListService.shared.fetchPhotosNextPage()
                    }
                    AlertPresenter.shared.presentAlert(title: "Что-то пошло не так!", message: "Не удалось загрузить изображения", actions: [alertActionTryAgain, alertActionCancel], target: topController)
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
            case .success(let photoInfo):
                
                self.photos = self.photos.map { $0.id == photoId ? photoInfo.photo : $0 }
                completion(.success(()))
                
            case.failure(let error):
                
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
