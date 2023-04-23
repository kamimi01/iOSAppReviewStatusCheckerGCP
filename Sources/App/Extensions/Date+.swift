//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/12.
//

import Foundation

extension Date {
    func stringFromDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "Asia/Tokyo")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
