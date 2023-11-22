//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 20.11.2023.
//

import Foundation


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScrope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScrope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScrope = accessScrope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: UnsplashData.accessKey,
            secretKey: UnsplashData.secretKey,
            redirectURI: UnsplashData.redirectURI,
            accessScrope: UnsplashData.accessScope,
            defaultBaseURL: UnsplashData.defaultBaseURL!,
            authURLString: UnsplashData.authorizeURLString)
    }
}
