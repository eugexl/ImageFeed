//
//  URLSessionExtension.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 06.10.2023.
//

import Foundation

extension URLSession {
    
    func getData(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let execCompletion: (Result<Data, Error>) -> Void = { result in
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
                
                execCompletion(.success(data))
                
            } catch {
                execCompletion(.failure(error))
            }
        }
        
        task.resume()
    }
}
