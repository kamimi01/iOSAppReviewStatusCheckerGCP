//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Foundation

// - seealso: https://api.slack.com/methods/chat.postMessage
struct PostMessageRequest: SlackRequest {
    typealias Response = PostMessageResponse

    let postMessage: PostMessage?

    var method: HttpMethod = .post
    var path = "/chat.postMessage"

    var headerFields: [String : String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(botToken)"
        ]
    }

    var queryParameters: [String : String]? = nil

    var body: Data? {
        guard let postMessage = postMessage else { return nil }

        let body: [String: Any] = [
            "token": botToken,
            "channel": postMessage.channel,
            "text": postMessage.text
        ]

        return try! JSONSerialization.data(withJSONObject: body)
    }
}
