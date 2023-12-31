//
//  URLRequests.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 14.10.2023.
//

import Foundation

struct URLRequests {
    
    static let shared = URLRequests()
    
    private var token: String {
        get {
            return OAuth2TokenStorage.shared.token ?? ""
        }
    }
    
    let httpMethodPost = "POST"
    let httpMethodDelete = "DELETE"
    
    private init() {}
    
    func authTokenRequest(code: String) throws -> URLRequest {
        
        var urlComponents = URLComponents(string: UnsplashData.tokenRequestURLString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: UnsplashData.accessKey),
            URLQueryItem(name: "client_secret", value: UnsplashData.secretKey),
            URLQueryItem(name: "redirect_uri", value: UnsplashData.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = URLRequests.shared.httpMethodPost
        
        return request
    }
    
    func photoLike(photoId: String, isLike: Bool) -> URLRequest {
        
        guard let url = UnsplashData.likePhotoURL(photoId: photoId) else {
            fatalError("URLRequests.photoLike: Не получилось создать URL для запроса photo/:id/like")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? URLRequests.shared.httpMethodPost : URLRequests.shared.httpMethodDelete
        
        return request
    }
    
    func photoListRequest(page num: Int) -> URLRequest {
        
        guard let url = UnsplashData.getPhotoListURL(page: num) else {
            fatalError("Couldn''t create URL for GETting page list data")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func profileMeRequest() -> URLRequest {
        
        guard let url = UnsplashData.getMeRequestURL else {
            fatalError("Couldn''t create URL for GETting me-profile data")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func userDataRequest(of username: String) -> URLRequest {
        
        guard let url = UnsplashData.getUserDataRequestURL(of: username) else {
            fatalError("Couldn''t create URL for GETting me-profile data")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
