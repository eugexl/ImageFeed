//
//  ViewController.swift
//
//  ImageFeed App
//
//  Created by Eugene Dmitrichenko on 26.08.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private lazy var photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let SingleImageSegue = "SingleImageSegue"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SingleImageSegue {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - TableView Delegate Extension
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let image = UIImage(named: String(indexPath.row)) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let aspectScale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * aspectScale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SingleImageSegue, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TableView Data Source Extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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
        
        guard let image = UIImage(named: String(indexPath.row)) else {
            return
        }
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let likeImage = indexPath.row % 2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

