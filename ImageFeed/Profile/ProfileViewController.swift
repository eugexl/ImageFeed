//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 11.09.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    
    var presenter: ProfilePresenterProtocol { get set }
    
    func fillUpElements(with: Profile)
    func setAvatar(with url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol = ProfilePresenter()
    
    private let exitButton: UIButton = {
        let exitButtonImage = "ExitButton"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: exitButtonImage), for: .normal)
        button.accessibilityIdentifier = "ExitButton"
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private let profilePhoto: UIImageView = {
        let imageName = NamedImages.profileImagePlaceholder
        let imageView = UIImageView(image: UIImage(named: imageName))
        return imageView
    }()
    
    private let profileTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP Gray")
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        setUpUI()
        
        presenter.viewDidLoad(with: self)
    }
    
    @objc
    private func exitButtonTapped() {
        
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let alertActionYes = UIAlertAction(title: "Да", style: .cancel) { [weak self] _ in
            self?.presenter.leaveApp()
        }
        
        alert.addAction(alertActionYes)
        
        let alertActionNo = UIAlertAction(title: "Нет", style: .default)
        alert.addAction(alertActionNo)
        
        alert.preferredAction = alertActionNo
        
        present(alert, animated: true)
    }
    
    func fillUpElements(with profile: Profile){
        
        nameLabel.text = profile.name
        userIdLabel.text = profile.loginName
        profileTextLabel.text = profile.bio
    }
    
    private func setUpUI() {
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        [nameLabel,
         userIdLabel,
         profileTextLabel,
         profilePhoto,
         exitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 76.0),
            profilePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhoto.widthAnchor.constraint(equalToConstant: 70.0),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70.0),
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8.0),
            nameLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            userIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            userIdLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileTextLabel.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 8.0),
            profileTextLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44.0),
            exitButton.heightAnchor.constraint(equalToConstant: 44.0),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 86.0),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }
    
    func setAvatar(with url: URL) {
        
//        ImageCache.default.clearDiskCache()
//        ImageCache.default.clearMemoryCache()
        
        let roundCornerEffect = RoundCornerImageProcessor(cornerRadius: 35)
        profilePhoto.kf.indicatorType = .activity
        profilePhoto.kf.setImage(
            with: url,
            placeholder: UIImage(named: NamedImages.profileImagePlaceholder),
            options: [.processor(roundCornerEffect), .cacheSerializer(FormatIndicatedCacheSerializer.png)] )
    }
}
