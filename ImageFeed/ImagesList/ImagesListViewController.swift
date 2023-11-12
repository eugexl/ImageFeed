//
//  ViewController.swift
//
//  ImageFeed App
//
//  Created by Eugene Dmitrichenko on 26.08.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private lazy var photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private var photos: [Photo] = []
    
    private let singleImageSegue = "SingleImageSegue"
    
    private var timeToFetchPhotos: Int = 0
    
    private var tableView: UITableView = {
        
        let table = UITableView()
        table.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return table
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(forName: ImageListService.DidChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        
        ImageListService.shared.fetchPhotosNextPage()
        setUpUI()
    }
    
    private func setUpUI(){
        
        view.backgroundColor = UIColor(named: ColorNames.ypBlack)
        view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.backgroundColor = UIColor(named: ColorNames.ypBlack)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateTableViewAnimated() {
        
        let oldPhotosNum = photos.count
        photos = ImageListService.shared.photos
        let newPhotosNum = photos.count
        
        timeToFetchPhotos = photos.count - 1
        
        if newPhotosNum > oldPhotosNum {
            
            tableView.performBatchUpdates {
                let indexPaths: [IndexPath] = (oldPhotosNum..<newPhotosNum).map { i in
                    return IndexPath(row: i, section: 0)
                }
                
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - TableView Delegate Extension
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let photoInfo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let aspectScale = imageViewWidth / photoInfo.size.width
        let cellHeight = photoInfo.size.height * aspectScale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let imageVC = SingleImageViewController()
        let image = UIImage(named: photosName[indexPath.row])
        
        imageVC.image = image
        imageVC.modalPresentationStyle = .fullScreen
        self.present(imageVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == timeToFetchPhotos {
            ImageListService.shared.fetchPhotosNextPage()
        }
    }
}

// MARK: - TableView Data Source Extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return photosName.count
        
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    /// Настраиваем отображение ячейки таблицы
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let photoInfo = ImageListService.shared.photos[indexPath.row]
        
        guard let url = URL(string: photoInfo.thumbImageURL), let createdAt = photoInfo.createdAt else {
            
            print("ImageListViewController, configCell: Не получилось подготовить данные для ячейки таблицы")
            return
        }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: NamedImages.stubPhoto)) { [weak self] _ in
            
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
       
        cell.dateLabel.text = DateFormatters.imageListDateFormatter.string(from: createdAt)
        
        let likeImage = indexPath.row % 2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

