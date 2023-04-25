import Vapor

func routes(_ app: Application) throws {
    app.post("postAppStoreState") { req async throws in
        // TODO: Controllerクラスに処理を委譲して、エラーレスポンスのハンドリングをする
        let postAppStoreState = try req.content.decode(PostAppStoreState.self)
        let appIDs = postAppStoreState.appIDs
        if appIDs.isEmpty || postAppStoreState.channelID.isEmpty {
            throw Abort(.badRequest, reason: "no required path paramter appID or channelID")
        }

        let usecase = PostAppStateToSlackUseCase(app: app, req: req)
        let result = try await usecase.postAppStateToSlack(
            appIDs: appIDs,
            channelID: postAppStoreState.channelID
        )

        return result
    }
}
