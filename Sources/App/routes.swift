import Vapor

func routes(_ app: Application) throws {
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

    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
