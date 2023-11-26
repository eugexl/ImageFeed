//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//

import Foundation
import Kingfisher

public protocol ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol { get set }
    
    func viewDidLoad(with view: ImagesListViewControllerProtocol)
    func willDisplay(row: Int)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    var imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    
    private var currentPhotoNumber: Int = 0
    private var timeToFetchPhotos: Int = 0
    
    func viewDidLoad(with view: ImagesListViewControllerProtocol){
        
        self.view = view
        
        NotificationCenter.default.addObserver(forName: ImagesListService.DidChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updatePhotoList()
        }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    func updatePhotoList() {
        
        let newPhotosNum = imagesListService.photos.count
        
        if newPhotosNum > currentPhotoNumber {
            
            let indexPaths: [IndexPath] = (currentPhotoNumber..<newPhotosNum).map { i in
                return IndexPath(row: i, section: 0)
            }
            
            view?.updateList(with: imagesListService.photos, at: indexPaths)
        }
        
        currentPhotoNumber = imagesListService.photos.count
        timeToFetchPhotos = currentPhotoNumber - 1
    }
    
    func willDisplay(row: Int){
        
        if row == timeToFetchPhotos {
            
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListPresenter: ImagesListCellDelegate {
    func imagesListCellDidTapLike(on cell: ImagesListCell) {
        
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        
        let photoInfo = imagesListService.photos[indexPath.row]
        let newLikeState = !photoInfo.isLiked
        
        imagesListService.changeLike(photoId: photoInfo.id, isLike: newLikeState) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                
                cell.setIsLiked(state: newLikeState)
                
            case .failure:
                
                view?.likeWarn()
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike (on cell: ImagesListCell)
}

