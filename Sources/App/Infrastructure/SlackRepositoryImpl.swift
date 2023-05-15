//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/19.
//

import Vapor

enum SlackRepositoryError: Error {
    case unexpectedError(String?)
}

protocol SlackRepository {
    func post(to channelID: String, message: String, req: Vapor.Request) async throws -> PostMessageRequest.Response
}

class SlackRepositoryImpl: SlackRepository {
    /// Slack にメッセージを投稿する
    func post(to channelID: String, message: String, req: Vapor.Request) async throws -> PostMessageRequest.Response {
        let client = VaporAPIClient(req: req)
        let request = PostMessageRequest(postMessage: PostMessage(channel: channelID, text: message))
        let result = try await client.request(request)

        if result.ok == false {
            throw SlackRepositoryError.unexpectedError(result.error)
        }

        return result
    }
}
