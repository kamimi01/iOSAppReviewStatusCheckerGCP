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
    let message: MessageResponse?
    let error: String?

    init(ok: Int, channelID: String?, message: MessageResponse?, error: String?) {
        print(ok)
        self.ok = (ok == 1) ? true : false
        self.channelID = channelID
        self.message = message
        self.error = error
    }
}

struct MessageResponse: Decodable {
    let text: String
}
