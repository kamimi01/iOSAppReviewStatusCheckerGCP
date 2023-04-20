import Vapor
import JWT

// TODO: 複数アプリのステータスを投稿できるように
// TODO: 期限が切れていないJWTがあったらそれを使用するように
// TODO: APIではなく、バッチとして実装するように
func routes(_ app: Application) throws {
    app.get("postReviewSubmissionState") { req async in
        let appID = "1673161138"

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
        } catch {
            return "unexpectedError: \(error)"
        }

        return "success"
    }
}
