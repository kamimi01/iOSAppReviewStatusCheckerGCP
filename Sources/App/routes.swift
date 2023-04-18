import Vapor
import JWT

// TODO: 複数アプリのステータスを投稿できるように
// TODO: アプリ名とバージョンを取得できるように
// TODO: 期限が切れていないJWTがあったらそれを使用するように
// TODO: APIではなく、バッチとして実装するように
func routes(_ app: Application) throws {
    app.get { req async in
        let appID = "1673161138"

        do {
            // App Store Connectから審査情報を取得する
            let ascController = AppStoreConnectController(app: app, req: req, appIDs: [appID])
            let reviewSubmissions = try await ascController.requestReviewSubmission()

            // 投稿するメッセージを生成する
            let messageGenerator = MessageGenerator()
            let postMessage = try messageGenerator.generatePostMessage(
                appID: appID,
                submittedDate: reviewSubmissions.data.first?.attributes.submittedDate,
                state: reviewSubmissions.data.first?.attributes.state
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
