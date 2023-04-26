import Vapor

func routes(_ app: Application) throws {
    let protected = app.grouped(UserAuthenticator())

    protected.post("postAppStoreState") { req async throws in
        let controller = AppStoreStateController(app: app, req: req)
        let result = try await controller.postAppStoreState(req: req)
        return result
    }
}
