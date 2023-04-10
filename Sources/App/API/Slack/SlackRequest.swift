//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Foundation

protocol SlackRequest: Request {}

extension SlackRequest {
    var baseURL: URL {
        return URL(string: "https://slack.com/api/")!
    }
}
