//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 05.10.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let authTokenRequest =  URLRequests.shared.authTokenRequest(code: code)
         
        let task = URLSession.shared.objectTask(for: authTokenRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let authBody):
                
                completion(.success(authBody.accessToken))
                self.task = nil
                self.lastCode = nil
                
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
