//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 21.11.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
//    var timeToFetchPhotos: Int { get set }
    
    func viewDidLoad(with view: ImagesListViewControllerProtocol)
    func largePhotoURL(for row: Int) -> URL?
    func numberOfPhotos() -> Int
    func photoForRow(at row: Int) -> Photo
    func willDisplay(row: Int)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    var timeToFetchPhotos: Int = 0
    
    func viewDidLoad(with view: ImagesListViewControllerProtocol){
        
        self.view = view
        
        NotificationCenter.default.addObserver(forName: ImagesListService.DidChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updatePhotoList()
        }
        
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func largePhotoURL(for row: Int) -> URL? {
        
        return URL(string: photos[row].largeImageURL)
    }
    
    func numberOfPhotos() -> Int {
        
        return photos.count
    }
    
    func photoForRow(at row: Int) -> Photo {
        
        return photos[row]
    }
    
    func updatePhotoList() {
        
        let oldPhotosNum = photos.count
        photos = ImagesListService.shared.photos
        let newPhotosNum = photos.count
        
        timeToFetchPhotos = photos.count - 1
        
        if newPhotosNum > oldPhotosNum {
            
            let indexPaths: [IndexPath] = (oldPhotosNum..<newPhotosNum).map { i in
                return IndexPath(row: i, section: 0)
            }
            
            view?.updateTableViewAnimated(at: indexPaths)
        }
    }
    
    func willDisplay(row: Int){
        
        if row == timeToFetchPhotos {
            
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

extension ImagesListPresenter: ImagesListCellDelegate {
    func imagesListCellDidTapLike(on cell: ImagesListCell) {
        
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        
        let photoInfo = photos[indexPath.row]
        let newLikeState = !photoInfo.isLiked
        
        ImagesListService.shared.changeLike(photoId: photoInfo.id, isLike: newLikeState) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                
                self.photos = ImagesListService.shared.photos
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

