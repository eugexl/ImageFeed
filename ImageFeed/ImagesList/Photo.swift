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
}
