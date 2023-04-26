//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Foundation

struct PostMessageResponse: Decodable {
    let ok: Bool
    let channel: String?
    let message: MessageResponse?
    let error: String?

    init(ok: Int, channel: String?, message: MessageResponse?, error: String?) {
        print(ok)
        self.ok = (ok == 1) ? true : false
        self.channel = channel
        self.message = message
        self.error = error
    }
}

struct MessageResponse: Decodable {
    let text: String
}
