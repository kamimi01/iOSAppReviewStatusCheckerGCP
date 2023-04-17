import Vapor
import JWT

func routes(_ app: Application) throws {
    app.get { req async in

        guard let token = generateJWT(req: req) else { return "" }

        let session = Session()

        // App Store Connect API をリクエストする
        let appID = "1673161138"
        let request = GetAppSubmissionsRequest(appId: appID, token: token)  // TopicGen

        do {
            let result = try await session.send(request)

            guard let postMessage = generatePostMessage(
                appID: appID,
                submittedDate: result.data.first?.attributes.submittedDate,
                state: result.data.first?.attributes.state
            ) else { return "cannot generate post message" }

            let sessionForSlackRequest = Session()
            let slackRequest = PostMessageRequest(postMessage: PostMessage(
                channel: channelID,
                text: postMessage)
            )

            let postResult = try await sessionForSlackRequest.send(slackRequest)
            print(postResult.ok, postResult.error)

        } catch {
            return "failed"
        }

        return "sample"
    }

    /// JWT を生成
    func generateJWT(req: Vapor.Request) -> String? {
        let privateKey = privateKey

        let payload = Payload(
            issuer: .init(value: issuerID),
            issuedAtClaim: .init(value: Date()),
            expiration: .init(value: Calendar.current.date(byAdding: .minute, value: 20, to: Date()) ?? Date()),
            audience: .init(value: ["appstoreconnect-v1"])
        )

        do {
            let key = try ECDSAKey.private(pem: privateKey)
            app.jwt.signers.use(.es256(key: key))
            let newToken = try req.jwt.sign(payload, kid: keyID)
            return newToken
        } catch {
            print("failed to generate jwt")
            return nil
        }
    }

    /// Slack に投稿するメッセージを生成
    func generatePostMessage(appID: String, submittedDate: String?, state: String?) -> String? {
        guard let submittedDate = submittedDate,
              let state = state else {
            return nil
        }

        // 日付のフォーマットがおかしいので直す
        guard let convertedSubmittedDate = submittedDate.dateFromString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
              let reviewState = ReviewState(rawValue: state)
        else { return nil }

        let stringSubmittedDate = convertedSubmittedDate.stringFromDate(format: "yyyy/MM/dd HH:mm:ss")

        let message = """
        iOS アプリの審査状況をお知らせします！🍎

        【TopicGen】
        提出日時：\(stringSubmittedDate)
        審査ステータス：\(reviewState.display) \(reviewState.emoji)
        """

        return message
    }
}
