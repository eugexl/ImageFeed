//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 15.10.2023.
//

import UIKit


final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private init() {}
    
    private (set) var avatarURL: String?
    
    private var task: URLSessionTask?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(of username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        let request = URLRequests.shared.userDataRequest(of: username)
        
        let task = URLSession.shared.objectTask(for: request) { [ weak self ] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userResult):
                
                self.task = nil
                
                guard let avatarURL = userResult.profileImage["small"] else { return }
                
                self.avatarURL = avatarURL
                
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": avatarURL])
                
                completion(.success( avatarURL ))
                
                
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
