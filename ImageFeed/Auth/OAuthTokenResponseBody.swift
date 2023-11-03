//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 05.10.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    
    let accessToken: String
    let createdAt: Int
    let scope: String
    let tokenType: String
}
