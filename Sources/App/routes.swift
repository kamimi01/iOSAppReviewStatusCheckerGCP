import Vapor

// TODO: 期限が切れていないJWTがあったらそれを使用するように
func routes(_ app: Application) throws {
    app.post("postAppStoreState") { req async throws in
        let postAppStoreState = try req.content.decode(PostAppStoreState.self)
        let appIDs = postAppStoreState.appIDs
        if appIDs.isEmpty || postAppStoreState.channelID.isEmpty {
            throw Abort(.badRequest, reason: "no required path paramter appID or channelID")
        }

        for appID in appIDs {
            // TODO: appIDの数だけ投稿されてしまったので修正する
            let usecase = PostAppStateToSlackUseCase(app: app, req: req)
            try await usecase.postAppStateToSlack(
                appID: appID,
                channelID: postAppStoreState.channelID
            )
        }

        return Response(status: .ok)
    }
}
