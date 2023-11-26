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
    let authURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScrope: String,
         authURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScrope = accessScrope
        self.authURLString = authURLString
    }
}
