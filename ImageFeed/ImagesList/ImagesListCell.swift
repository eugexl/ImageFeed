//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 04.09.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
   static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
