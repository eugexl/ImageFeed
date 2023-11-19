//
//  Constants.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 28.09.2023.
//

import Foundation

struct UnsplashData {
    
    static let accessKey = "5WmzEZFA0XIUqHfm0sRalwInRzk70w9YK6FSOTRn-nw"
    static let secretKey = "VNQJRTqyR8xj02sWpQN68HBwLxAgQFmZBYkoMJE-Jh0"
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultBase = "https://api.unsplash.com"
    static let defaultBaseURL = URL(string: defaultBase)
    
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let tokenRequestURLString = "https://unsplash.com/oauth/token"
    
    static let getMeRequestURL = URL(string: "https://api.unsplash.com/me")
    static func getUserDataRequestURL(of username: String) -> URL? {
        return URL(string: "https://api.unsplash.com/users/\(username)")
    }
    
    static func getPhotoListURL(page num: Int) -> URL? {
        return URL(string: "https://api.unsplash.com/photos?page=\(num)")
    }
    
    static func likePhotoURL(photoId: String) -> URL? {
        return URL(string: "\(defaultBase)/photos/\(photoId)/like")
    }
    
    static let httpMethodPost = "POST"
    static let httpMethodDelete = "DELETE"
}

struct VCs {
    
    static let tabBarVC = "TabBarViewController"
}

struct NamedImages {
    static let authWebBackButton = "AuthWebBackButton"
    static let buttonBack = "BackButtonChevron"
    static let buttonShare = "SharingButton"
    static let likeButtonActive = "Active"
    static let likeButtonNoActive = "NoActive"
    static let profileImagePlaceholder = "ProfileImagePlaceholder"
    static let splashScreenLogoImage = "LaunchLogo"
    static let stubPhoto = "StubPhoto"
    static let tabBarItemImageList = "TabBarIconImageList"
    static let tabBarItemProfile = "TabBarIconProfile"
    static let unsplashLogo = "UnsplashLogoWhite"
}

struct ColorNames {
    static let ypBackground = "YP Background"
    static let ypBlack = "YP Black"
    static let ypGray = "YP Gray"
    static let ypWhite = "YP White"
}

struct NotificationNames {
    static let imagesListServiceDidChange = "ImagesListServiceDidChange"
}
