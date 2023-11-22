//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 22.11.2023.
//

import ImageFeed
import UIKit


final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol = ImagesListPresenterSpy()
        
    
    var tableView: UITableView = {
        UITableView()
    }()
    
    func updateTableViewAnimated(at indexPaths: [IndexPath]) {
    }
    
    func likeWarn() {
    }
    
    
}
