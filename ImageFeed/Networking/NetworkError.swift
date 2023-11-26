//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 06.10.2023.
//

import Foundation

/// Описание сетевых ошибок
enum NetworkError: Error {
    case httpResponseError
    case httpStatusCode(Int)
    case invalidURL
    case noDataError
}
