import Vapor

func routes(_ app: Application) throws {
    let protected = app.grouped(UserAuthenticator())

    protected.post("postAppStoreState") { req async throws in
        // FIXME: usecase でも controller の初期化でも app と req を渡しているのは変なので、直したい
        let usecase = PostAppStateToSlackUseCaseImpl(
            appRepository: AppRepositoryImpl(),
            appStoreVersionRepository: AppStoreVersionRepositoryImpl(),
            slackRepository: SlackRepositoryImpl(),
            messageRepository: MessageRepositoryImpl(),
            app: app,
            req: req
        )
        let controller = AppStoreStateController(usecase: usecase, app: app, req: req)
        let result = try await controller.postAppStoreState(req: req)
        return result
    }
}
