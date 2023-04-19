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
    let attributes: ReviewSubmissionAttributes

    init(attributes: ReviewSubmissionAttributes) {
        self.attributes = attributes
    }
}

struct ReviewSubmissionAttributes: Decodable {
    let submittedDate: String
    let state: String
}
