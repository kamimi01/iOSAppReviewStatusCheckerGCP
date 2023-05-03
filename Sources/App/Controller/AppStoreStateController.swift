//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/27.
//

import Vapor

class AppStoreStateController {
    private let usecase: PostAppStateToSlackUseCase

    // TODO: usecaseを外からDIできるようにしたい
    init(app: Application, req: Vapor.Request) {
        self.usecase = PostAppStateToSlackUseCase(app: app, req: req)
    }

    func postAppStoreState(req: Vapor.Request) async throws -> PostAppStateToSlackDTO {
        _ = try req.auth.require(User.self).name
        let postAppStoreState = try req.content.decode(PostAppStoreState.self)
        let appIDs = postAppStoreState.appIDs
        if appIDs.isEmpty || postAppStoreState.channelID.isEmpty {
            throw Abort(.badRequest, reason: "no required path paramter appID or channelID")
        }

        do {
            let result = try await usecase.postAppStateToSlack(
                appIDs: appIDs,
                channelID: postAppStoreState.channelID
            )
            return result
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
    }
}
