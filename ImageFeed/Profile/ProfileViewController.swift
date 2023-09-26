//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 11.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profilePhoto: UIImageView = {
        let imageName = "ProfilePhoto"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(named: "YP White")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP Gray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP White")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exitButton: UIButton = {
        let exitButtonImage = "ExitButton"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: exitButtonImage), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        setUpUI()
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func exitButtonTapped() {
        
        print("Exit button tapped ...")
    }
    
    func setUpUI() {
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        view.addSubview(nameLabel)
        view.addSubview(userIdLabel)
        view.addSubview(profileTextLabel)
        view.addSubview(profilePhoto)
        view.addSubview(exitButton)
        
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
}
