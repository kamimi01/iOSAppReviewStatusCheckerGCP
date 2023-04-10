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
        let request = GetAppSubmissionsRequest(appId: "1673161138", token: token)  // TopicGen

        session.send(request) { result in
            switch result {
            case let .success(response):
                // TODO: レスポンスを次のリクエストに使用する
                print(response)

                let sessionForSlackRequest = Session()
                let slackRequest = PostMessageRequest(postMessage: PostMessage(
                    channel: channelID,
                    text: "テスト投稿！！")
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

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
