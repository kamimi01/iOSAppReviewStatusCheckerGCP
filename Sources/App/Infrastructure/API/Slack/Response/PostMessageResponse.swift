//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Foundation

struct PostMessageResponse: Decodable {
    let ok: Bool
    let channelID: String?
    let message: Message?
    let error: String?

    init(ok: Int, channelID: String?, message: Message?, error: String?) {
        print(ok)
        self.ok = (ok == 1) ? true : false
        self.channelID = channelID
        self.message = message
        self.error = error
    }
}

struct Message: Decodable {
    let text: String
}
