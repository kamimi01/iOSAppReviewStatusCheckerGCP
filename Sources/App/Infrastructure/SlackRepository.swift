//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/19.
//

import Foundation

enum SlackRepositoryError: Error {
    case unexpectedError(String?)
}

class SlackRepository {
    /// Slack にメッセージを投稿する
    func post(to channelID: String, message: String) async throws -> PostMessageRequest.Response {
        let session = Session()
        let request = PostMessageRequest(postMessage: PostMessage(channel: channelID, text: message))

        let result = try await session.send(request)

        if result.ok == false {
            throw SlackRepositoryError.unexpectedError(result.error)
        }

        return result
    }
}
