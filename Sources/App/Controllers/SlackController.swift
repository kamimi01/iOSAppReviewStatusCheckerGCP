//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/19.
//

import Foundation

enum SlackRequestError: Error {
    case unexpectedError(String?)
}

class SlackController {
    /// Slack にメッセージを投稿する
    func post(message: String) async throws {
        let session = Session()
        let request = PostMessageRequest(postMessage: PostMessage(channel: channelID, text: message))

        let result = try await session.send(request)

        if result.ok == false {
            throw SlackRequestError.unexpectedError(result.error)
        }
    }
}
