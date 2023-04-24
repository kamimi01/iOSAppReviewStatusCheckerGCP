//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/24.
//

import Foundation

class PostAppStateToSlackUseCase {
    // TODO: リポジトリをDI して使う
    private let appRepository: AppRepository
    private let appStoreVersionRepository: AppStoreVersionRepository
    private let slackRepository: SlackRepository

    init(appRepository: AppRepository, appStoreVersionRepository: AppStoreVersionRepository, slackRepository: SlackRepository) {
        self.appRepository = appRepository
        self.appStoreVersionRepository = appStoreVersionRepository
        self.slackRepository = slackRepository
    }

    // TODO: トークンは引数から無くして内部処理に隠蔽したい
    func postAppStateToSlack(appID: String, channelID: String, token: String) async throws -> PostAppStateToSlackDTO {
        // TODO: AppRepositoryへのfetchとAppStoreStateRepositoryのfetchは同時実行してOKなので、await を外して並行処理を実施できるように修正したい
        let app = try await appRepository.fetch(id: appID, token: token)

        let appStoreVersion = try await appStoreVersionRepository.fetch(id: appID, token: token)

        // TODO: メッセージの生成をする
        let postMessage = "テスト投稿"
        let slackPostResult = try await slackRepository.post(to: channelID, message: postMessage)

        return PostAppStateToSlackDTO(
            appID: appID,
            channelID: channelID,
            postMessage: postMessage
        )
    }
}
