//
//  DateFormatters.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 07.11.2023.
//

import Foundation


struct DateFormatters {
    
    static let iso8601DateFormatter = ISO8601DateFormatter()
    
    static let imageListDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
