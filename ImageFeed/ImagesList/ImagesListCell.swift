//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 04.09.2023.
//

import UIKit

public final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: ColorNames.ypWhite)
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.accessibilityIdentifier = "LikeButton"
        return button
    }()
    
    weak var delegate: ImagesListCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentMode = .scaleToFill
        backgroundColor = UIColor(named: ColorNames.ypBlack)
        shouldIndentWhileEditing = true
        
        contentView.contentMode = .scaleToFill
        contentView.clipsToBounds = true
        
        [ cellImage,
          likeButton,
          dateLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 44.0),
            
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
            
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 24.0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
            
        ])
        likeButton.addTarget(self, action: #selector(buttonLikeTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    @objc
    private func buttonLikeTapped(){
        
        delegate?.imagesListCellDidTapLike(on: self)
    }
    
    func setIsLiked(state: Bool) {
        
        let likeImage = state ? UIImage(named: "Active") : UIImage(named: "No Active")
        likeButton.setImage(likeImage, for: .normal)
    }
}
