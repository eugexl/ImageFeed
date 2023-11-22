//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 20.11.2023.
//

import Foundation

protocol AuthHelperProtocol {
    
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        
        self .configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: UnsplashData.authorizeURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: UnsplashData.accessKey),
            URLQueryItem(name: "redirect_uri", value: UnsplashData.redirectURI),
            URLQueryItem(name: "response_type", value: UnsplashData.responseType),
            URLQueryItem(name: "scope", value: UnsplashData.accessScope)
        ]
        
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == UnsplashData.authorizeNativePath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
