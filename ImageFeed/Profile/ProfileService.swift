//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 12.10.2023.
//

import Foundation


final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    private var task: URLSessionTask?
    
    private(set) var profile:  Profile?
   
    func fetchProfile(_ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        let request = URLRequests.shared.profileMeRequest()
        
        let task = URLSession.shared.objectTask(for: request) { [ weak self ] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                
                let username =  profileResult.username ?? ""
                let firstname = profileResult.firstName ?? ""
                let lastname = profileResult.lastName ?? ""
                let gotFirstName = firstname.isEmpty ? "" : " "
                
                let name = firstname + gotFirstName + lastname
                let bio = profileResult.bio ?? ""
                
                let profile = Profile(
                    username: username,
                    name: name,
                    bio: bio
                )
                
                self.profile = profile
                
                completion(.success(username))
                
                self.task = nil
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
