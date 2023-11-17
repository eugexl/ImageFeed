//
//  URLSessionExtension.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 06.10.2023.
//

import Foundation

extension URLSession {
    
    func objectTask<DataT: Decodable>(for request: URLRequest, completion: @escaping (Result<DataT, Error>) -> Void) -> URLSessionTask {
        
        let executeCompletion: (Result<DataT, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            
            do {
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.httpResponseError
                }
                
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.httpStatusCode(response.statusCode)
                }
                
                guard let data = data else {
                    throw NetworkError.noDataError
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodeData = try decoder.decode(DataT.self, from: data)
                
                executeCompletion(.success(decodeData))
                
            } catch {
                
                executeCompletion(.failure(error))
            }
        }
        
        return task
    }
}
