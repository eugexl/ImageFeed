//
//  Profile.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 12.10.2023.
//

import Foundation

struct Profile {
    
    var username: String
    var name: String
    var loginName: String {
        get {
            return "@\(username)"
        }
    }
    var bio: String
}
