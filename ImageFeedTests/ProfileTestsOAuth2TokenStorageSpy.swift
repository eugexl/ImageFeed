//
//  OAuth2TokenStorageSpy.swift
//  ImageFeedTests
//
//  Created by Eugene Dmitrichenko on 24.11.2023.
//

import ImageFeed
import Foundation

final class OAuth2TokenStorageSpy: OAuth2TokenStorageProtocol {
    
    static let shared = OAuth2TokenStorageSpy()
    
    var token: String?  = "SECRET TOKEN"
    
    private let authTokenKey: String = "OAuth2Token"
    
    private init() {}
    
    func clearToken (){
        
        token = nil
    }
}
