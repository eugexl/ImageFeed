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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let tokenRequestURLString = "https://unsplash.com/oauth/token"
    
    static let postMethod = "POST"
}

struct Segues {
    
    static let showWebView  = "ShowWebView"
    static let showAuthVC   = "ShowAuthViewController"
}

struct VCs {
    
    static let splashVC = "SplashViewController"
    static let tabBarVC = "TabBarViewController"
}
