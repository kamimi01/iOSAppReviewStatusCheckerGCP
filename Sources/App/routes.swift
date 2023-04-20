import Vapor
import JWT

// TODO: 複数アプリのステータスを投稿できるように
// TODO: 期限が切れていないJWTがあったらそれを使用するように
// TODO: APIではなく、バッチとして実装するように
func routes(_ app: Application) throws {
    app.post("postAppStoreState", ":appID") { req async throws in
        guard let appID = req.parameters.get("appID") else {
            throw Abort(.badRequest, reason: "no required path paramter appID")
        }
        print(appID)

        do {
            // App Store Connectから審査情報を取得する
            let ascController = AppStoreConnectController(app: app, req: req, appIDs: [appID])
            // アプリ名を取得する
            let apps = try await ascController.requestApps()
            // バージョンと作成日時、ステータスを取得する
            let appStoreVersions = try await ascController.requestAppStoreVersions(appID: appID)

            // 投稿するメッセージを生成する
            let messageGenerator = MessageGenerator()
            let postMessage = try messageGenerator.generatePostMessage(
                appName: apps.data.first?.attributes.name,
                appVersion: appStoreVersions.data.first?.attributes.versionString,
                createdDate: appStoreVersions.data.first?.attributes.createdDate,
                state: appStoreVersions.data.first?.attributes.appStoreState
            )

            // Slackに投稿する
            let slackController = SlackController()
            try await slackController.post(message: postMessage)
        } catch AppStoreConnectRequestError.cannotGenerateJWT {
            throw Abort(.unauthorized, reason: "Failed to generate JWT")
        } catch SlackRequestError.unexpectedError(let error) {
            throw Abort(.badRequest, reason: "slack request is bad: \(String(describing: error))")
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }

        return Response(status: .ok)
    }
}
