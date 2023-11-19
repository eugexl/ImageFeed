//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 18.11.2023.
//

import Foundation


struct PhotoResult: Decodable {
    
    let createdAt: String?
    let id: String
    let height: CGFloat
    let isLiked: Bool
    let urls: UrlsResult
    let welcomeDescription: String?
    let width: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case createdAt, height, id, urls, width
        case isLiked = "likedByUser"
        case welcomeDescription = "description"
    }
}
