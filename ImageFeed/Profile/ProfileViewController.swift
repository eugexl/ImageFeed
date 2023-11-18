//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 11.09.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let exitButton: UIButton = {
        let exitButtonImage = "ExitButton"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: exitButtonImage), for: .normal)
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
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        setUpUI()
        fillUpElements()
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else { return }
            
            self.updateAvatar()
        })
    }
    
    @objc
    private func exitButtonTapped() {
        
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let alertActionYes = UIAlertAction(title: "Да", style: .cancel) { [weak self] _ in
            
            guard let self = self else { return }
            self.leaveApp()
        }
        alert.addAction(alertActionYes)
        
        let alertActionNo = UIAlertAction(title: "Нет", style: .default)
        alert.addAction(alertActionNo)
        
        alert.preferredAction = alertActionNo
        
        present(alert, animated: true)
        
    }
    
    private func fillUpElements(){
        
        let profile = ProfileService.shared.profile
        
        nameLabel.text = profile?.name
        userIdLabel.text = profile?.loginName
        profileTextLabel.text = profile?.bio
        updateAvatar()
    }
    
    private func leaveApp() {
        
        // Зачишаем cookie
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        // Удаляем токен доступа к API
        OAuth2TokenStorage.shared.clearToken()
        
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid UIApplication Configuration")
        }
        
        let splashViewontroller = SplashViewController()
        
        window.rootViewController = splashViewontroller
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
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL, let url = URL(string: profileImageURL) else {
            print("Got problem with setting profile image (by URL)")
            return
        }
        
        let roundCornerEffect = RoundCornerImageProcessor(cornerRadius: 35)
        profilePhoto.kf.indicatorType = .activity
        profilePhoto.kf.setImage(with: url, placeholder: UIImage(named: NamedImages.profileImagePlaceholder) ,options: [.processor(roundCornerEffect),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
    }
}
