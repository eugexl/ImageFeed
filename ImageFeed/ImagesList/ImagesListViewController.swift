//
//  ViewController.swift
//
//  ImageFeed App
//
//  Created by Eugene Dmitrichenko on 26.08.2023.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    
    var presenter: ImagesListPresenterProtocol { get set }
    var tableView: UITableView { get set }
    
    
    func updateList(with photos: [Photo], at indexPaths: [IndexPath])
    func likeWarn()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    private ( set ) var photos: [Photo] = []
    var presenter: ImagesListPresenterProtocol = ImagesListPresenter()
    var alertPresenter: AlertPresenterProtocol = AlertPresenter.shared
    
    var tableView: UITableView = {
        
        let table = UITableView()
        table.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return table
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(with: self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    func updateList(with photos: [Photo], at indexPaths: [IndexPath]) {
        
        self.photos = photos
        
        // For Unit test's sake
        if self.viewIfLoaded?.window != nil {
            tableView.performBatchUpdates {
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func likeWarn(){
        
        let action = UIAlertAction(title: "ОК", style: .cancel)
        alertPresenter.presentAlert(
            title: "Что-то пошло не так!",
            message: "К сожалению, не удалось поставить лайк данному изображению",
            actions: [action],
            target: self
        )
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let imageVC = SingleImageViewController()
        imageVC.imageURL = URL(string: photos[indexPath.row].largeImageURL)
        
        imageVC.modalPresentationStyle = .fullScreen
        self.present(imageVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        presenter.willDisplay(row: indexPath.row)
    }
}

// MARK: - TableView Data Source Extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: photos[indexPath.row])
        
        return imageListCell
    }
    
    /// Настраиваем отображение ячейки таблицы
    func configCell(for cell: ImagesListCell, with photo: Photo) {
        
        if let url = URL(string: photo.thumbImageURL) {
            
            let roundCornerEffect = RoundCornerImageProcessor(cornerRadius: 8.0)
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: NamedImages.stubPhoto), options: [.processor(roundCornerEffect)])
            
        } else {
            
            cell.cellImage.image = UIImage(named: NamedImages.stubPhoto)
        }
        
        if let createdAt = photo.createdAt {
            
            cell.dateLabel.text = DateFormatters.imageListDateFormatter.string(from: createdAt)
        } else {
            
            cell.dateLabel.text = ""
        }
        
        cell.setIsLiked(state: photo.isLiked)
        
        cell.delegate = presenter as? ImagesListCellDelegate
    }
}
