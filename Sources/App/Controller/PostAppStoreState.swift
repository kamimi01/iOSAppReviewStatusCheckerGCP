//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/21.
//

import Vapor

struct PostAppStoreState: Content {
    private(set) var channelID: String
    private(set) var appIDs: [String]
}
