//
//  Profile.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 12.10.2023.
//

import Foundation

struct Profile {
    
    var bio: String
    var loginName: String {
        get {
            return "@\(username)"
        }
    }
    var name: String
    var username: String
}
