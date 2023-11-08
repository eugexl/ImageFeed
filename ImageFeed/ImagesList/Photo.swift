//
//  Photo.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 06.11.2023.
//

import Foundation

struct Photo: Decodable {
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case createdAt, height, id, urls, width
        case isLiked = "likedByUser"
        case welcomeDescription = "description"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        
        let height = try container.decode(CGFloat.self, forKey: .height)
        let width = try container.decode(CGFloat.self, forKey: .width)
        self.size = CGSize(width: width, height: height)
        
        if let createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            self.createdAt = DateFormatters.iso8601DateFormatter.date(from: createdAt)
        } else {
            self.createdAt = nil
        }
        
        self.welcomeDescription = try container.decodeIfPresent(String.self, forKey: .welcomeDescription)
        
        let urls = try container.decode(PhotoURLs.self, forKey: .urls)
        self.thumbImageURL = urls.thumb
        self.largeImageURL = urls.full
        
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
    }
}

