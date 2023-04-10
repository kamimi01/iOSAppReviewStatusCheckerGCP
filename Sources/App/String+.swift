//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/11.
//

import Foundation

extension String {
    func dateFromString(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
