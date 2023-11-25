//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 07.10.2023.
//

import Foundation
import SwiftKeychainWrapper

public protocol OAuth2TokenStorageProtocol {
    
    func clearToken()
}

/// Сингтон для сохранения / возвращения OAuth2-токена в/из UserDefaults-репозитория
final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        
        get {
            return KeychainWrapper.standard.string(forKey: authTokenKey)
        }
        set {
            let token = newValue ?? ""
            KeychainWrapper.standard.set(token, forKey: authTokenKey)
        }
    }
    
    private let authTokenKey: String = "OAuth2Token"
    
    private init() {}
    
    func clearToken (){
        
        KeychainWrapper.standard.removeObject(forKey: authTokenKey)
    }
}
