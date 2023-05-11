//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/10.
//

import Vapor

// - seealso: https://api.slack.com/methods/chat.postMessage
struct PostMessageRequest: SlackRequest {
    typealias Response = PostMessageResponse

    let postMessage: PostMessage?

    var method: HttpMethod = .post
    var path = "/chat.postMessage"

    var headerFields: [String : String]? {
        guard let botToken = Environment.get("SLACK_BOT_TOKEN") else { return nil }

        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(botToken)"
        ]
    }

    var queryParameters: [String : String]? = nil

    var body: [String: Any]? {
        guard let postMessage = postMessage,
              let botToken = Environment.get("SLACK_BOT_TOKEN")
        else { return nil }

        return [
            "token": botToken,
            "channel": postMessage.channel,
            "text": postMessage.text
        ]
    }
}
