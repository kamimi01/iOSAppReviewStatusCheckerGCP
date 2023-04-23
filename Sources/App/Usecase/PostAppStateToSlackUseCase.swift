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

    init(appRepository: AppRepository, appStoreVersionRepository: AppStoreVersionRepository) {
        self.appRepository = appRepository
        self.appStoreVersionRepository = appStoreVersionRepository
    }

    // TODO: トークンは引数から無くして内部処理に隠蔽したい
    func postAppStateToSlack(appID: String, token: String) async throws -> PostAppStateToSlackDTO {
        // TODO: AppRepositoryへのfetchとAppStoreStateRepositoryのfetchは同時実行してOKなので、await を外して並行処理を実施できるように修正したい
        let app = try await appRepository.fetch(id: appID, token: token)

        let appStoreVersion = try await appStoreVersionRepository.fetch(id: appID, token: token)

        // TODO: 実際にSlack にポストする（Slackポストはリポジトリに実装する）


        // TODO: DTOはchannelID, messageを返せばいい
        return PostAppStateToSlackDTO(
            appID: appID,
            appName: app.name,
            version: appStoreVersion.version,
            createdDate: appStoreVersion.createdDate,
            appState: appStoreVersion.appStoreState,
            appStateEmoji: AppStoreState(rawValue: appStoreVersion.appStoreState.rawValue)!.emoji
        )
    }
}
