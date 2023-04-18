import Vapor
import JWT

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
