//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 05.10.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let authTokenRequest =  authTokenRequest(code: code)
        
        oauthQuery(with: authTokenRequest) { result in
            
            switch result {
                
            case .success(let authBody):
                
                completion(.success(authBody.accessToken))
                
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        
        var urlComponents = URLComponents(string: UnsplashData.tokenRequestURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: UnsplashData.accessKey),
            URLQueryItem(name: "client_secret", value: UnsplashData.secretKey),
            URLQueryItem(name: "redirect_uri", value: UnsplashData.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = UnsplashData.postMethod
        
        return request
    }
    
    private func oauthQuery(with request: URLRequest, completion: @escaping (Result <OAuthTokenResponseBody, Error>) -> Void) {
        
        URLSession.shared.getData(for: request) { result in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let oauthResponse = result.flatMap { data in
                Result {try decoder.decode(OAuthTokenResponseBody.self, from: data)}
            }
            
            completion(oauthResponse)
        }
    }
}
