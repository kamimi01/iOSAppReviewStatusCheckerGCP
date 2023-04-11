import Vapor
import JWT

func routes(_ app: Application) throws {
    app.get { req async in
        // JWTを生成
        let privateKey = privateKey

        let payload = Payload(
            issuer: .init(value: issuerID),
            issuedAtClaim: .init(value: Date()),
            expiration: .init(value: Calendar.current.date(byAdding: .minute, value: 20, to: Date()) ?? Date()),
            audience: .init(value: ["appstoreconnect-v1"])
        )

        var token = ""
        do {
            let key = try ECDSAKey.private(pem: privateKey)
            app.jwt.signers.use(.es256(key: key))
            let newToken = try req.jwt.sign(payload, kid: keyID)
            token = newToken
            print(token)
        } catch {
            print("エラー発生")
        }

        let session = Session()

        // App Store Connect API をリクエストする
        let appID = "1673161138"
        let request = GetAppSubmissionsRequest(appId: appID, token: token)  // TopicGen

        session.send(request) { result in
            switch result {
            case let .success(response):
                // TODO: レスポンスを次のリクエストに使用する
                print(response)

                guard let postMessage = generatePostMessage(
                    appID: appID,
                    submittedDate: response.data.first?.attributes.submittedDate,
                    state: response.data.first?.attributes.state
                ) else { return Void()}

                let sessionForSlackRequest = Session()
                let slackRequest = PostMessageRequest(postMessage: PostMessage(
                    channel: channelID,
                    text: postMessage)
                )
                sessionForSlackRequest.send(slackRequest) { resultForSlack in
                    switch resultForSlack {
                    case let .success(slackResponse):
                        print(slackResponse)
                    case let .failure(errorForSlack):
                        print(errorForSlack)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }

        return "sample"
    }

    /*
     最終形態
     ```
     審査状況をお知らせします！🍎

     アプリ名：[アプリ名] 📱
     バージョン：v10.45 🚀
     提出日時：2023/02/21 21:05:34 🗓️
     審査ステータス：審査中 🤞
     ```
     */
    func generatePostMessage(appID: String, submittedDate: String?, state: String?) -> String? {
        guard let submittedDate = submittedDate,
              let state = state else {
            return nil
        }

        // TODO: 日付のフォーマットがおかしいので直す
        guard let convertedSubmittedDate = submittedDate.dateFromString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
              let reviewState = ReviewState(rawValue: state)
        else { return nil }

        let stringSubmittedDate = convertedSubmittedDate.stringFromDate(format: "yyyy/MM/dd HH:mm:ss")

        let message = """
        【TopicGen】
        提出日時：\(stringSubmittedDate)
        審査ステータス：\(reviewState.display) \(reviewState.emoji)
        """

        return message
    }
}
