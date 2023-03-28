//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/28.
//

import Foundation

struct ReviewSubmission: Decodable {
    let data: [ReviewData]

    init(data: [ReviewData]) {
        self.data = data
    }
}

struct ReviewData: Decodable {
    let attributes: Attributes

    init(attributes: Attributes) {
        self.attributes = attributes
    }
}

struct Attributes: Decodable {
    let submittedDate: String
    let state: String
}
