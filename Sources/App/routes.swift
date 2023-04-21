import Vapor

// TODO: 期限が切れていないJWTがあったらそれを使用するように
func routes(_ app: Application) throws {
    app.post("postAppStoreState") { req async throws in
        let postAppStoreState = try req.content.decode(PostAppStoreState.self)
        let appIDs = postAppStoreState.appIDs
        if appIDs.isEmpty || postAppStoreState.channelID.isEmpty {
            throw Abort(.badRequest, reason: "no required path paramter appID or channelID")
        }

        // App Store Connectから審査情報を取得する
        let ascController = AppStoreConnectController(app: app, req: req)
        // 投稿するメッセージを生成する
        let messageGenerator = MessageGenerator()
        var postMessages = "iOS アプリのステータスをお知らせします🍎\n\n"

        for appID in appIDs {
            do {
                // アプリ名を取得する
                let appName = try await ascController.requestApp(appID: appID)

                // バージョンと作成日時、ステータスを取得する
                let appStoreVersions = try await ascController.requestAppStoreVersions(appID: appID)

                // 投稿するメッセージを生成する
                let postMessage = try messageGenerator.generatePostMessage(
                    appName: appName,
                    appVersion: appStoreVersions.data.first?.attributes.versionString,
                    createdDate: appStoreVersions.data.first?.attributes.createdDate,
                    state: appStoreVersions.data.first?.attributes.appStoreState
                )
                postMessages += postMessage
            } catch AppStoreConnectRequestError.cannotGenerateJWT {
                throw Abort(.unauthorized, reason: "appID is \(appID)\nFailed to generate JWT")
            } catch {
                throw Abort(.badRequest, reason: "appID is \(appID)\n\(error.localizedDescription)")
            }
        }

        do {
            // Slackに投稿する
            let slackController = SlackController()
            try await slackController.post(to: postAppStoreState.channelID, message: postMessages)
        } catch SlackRequestError.unexpectedError(let error) {
            throw Abort(.badRequest, reason: "slack request is bad: \(String(describing: error))")
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }

        return Response(status: .ok)
    }
}
