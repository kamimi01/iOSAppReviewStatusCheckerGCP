import Vapor
import JWT

func routes(_ app: Application) throws {
//    let session = Session()
//
//    // TODO: App Store Connect API をリクエストする
//    let request = GetAppSubmissionsRequest(appId: "1673161138")  // TopicGen
//    let generator = JWTGenrator(app: app)
//    let token = generator.generateJWT()
//    print(token)
//
//    session.send(request) { result in
//        switch result {
//        case let .success(response):
//            // TODO: レスポンスを次のリクエストに使用する
//            print(response)
//        case let .failure(error):
//            print(error)
//        }
//    }

    app.get { req async in
        // TODO: JWTを生成
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
            let token = try req.jwt.sign(payload, kid: keyID)
            print(token)
        } catch {
            print("エラー発生")
        }

        let session = Session()

        // TODO: App Store Connect API をリクエストする
        let request = GetAppSubmissionsRequest(appId: "1673161138")  // TopicGen

        session.send(request) { result in
            switch result {
            case let .success(response):
                // TODO: レスポンスを次のリクエストに使用する
                print(response)
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
