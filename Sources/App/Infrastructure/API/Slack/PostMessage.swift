//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Foundation

struct PostMessage {
    let channel: String
    let text: String

    init(channel: String, text: String) {
        self.channel = channel
        self.text = text
    }
}
