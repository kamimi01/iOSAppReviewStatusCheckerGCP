//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/24.
//

import Vapor

struct PostAppStateToSlackDTO: Content {
    let appIDs: [String]
    let channelID: String
    let postMessage: String
}
