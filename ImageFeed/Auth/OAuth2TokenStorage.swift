//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 07.10.2023.
//

import Foundation

/// Сингтон для сохранения / возвращения OAuth2-токена в/из UserDefaults-репозитория
final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let authTokenKey: String = "authToken"
    
    var token: String? {
        
        get {
            return UserDefaults.standard.string(forKey: authTokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: authTokenKey)
        }
    }
    
    func clearToken (){
        
        UserDefaults.standard.removeObject(forKey: authTokenKey)
    }
}
