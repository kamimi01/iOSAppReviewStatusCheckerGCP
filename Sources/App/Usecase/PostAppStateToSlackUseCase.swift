//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/24.
//

import Vapor
import JWT

class PostAppStateToSlackUseCase {
    // TODO: リポジトリをDI して使う
    private let appRepository: AppRepository
    private let appStoreVersionRepository: AppStoreVersionRepository
    private let slackRepository: SlackRepository
    private let messageRepository: MessageRepository

    private var token: String?
    private let app: Application
    private let req: Vapor.Request

    init(appRepository: AppRepository = AppRepository(), appStoreVersionRepository: AppStoreVersionRepository = AppStoreVersionRepository(), slackRepository: SlackRepository = SlackRepository(), messageRepository: MessageRepository = MessageRepository(), app: Application, req: Vapor.Request) {
        self.appRepository = appRepository
        self.appStoreVersionRepository = appStoreVersionRepository
        self.slackRepository = slackRepository
        self.messageRepository = messageRepository
        self.app = app
        self.req = req
    }

    func postAppStateToSlack(appIDs: [String], channelID: String) async throws -> PostAppStateToSlackDTO {
        guard let jwt = generateJWT() else {
            throw AppStoreConnectRequestError.cannotGenerateJWT
        }

        // TODO: AppRepositoryへのfetchとAppStoreStateRepositoryのfetchは同時実行してOKなので、await を外して並行処理を実施できるように修正したい
        var messages = [Message]()
        for appID in appIDs {
            let app = try await appRepository.fetch(id: appID, token: jwt, req: req)

            let appStoreVersion = try await appStoreVersionRepository.fetch(id: appID, token: jwt, req: req)

            let messageForApp = try messageRepository.generateMessageForApp(appInfo: app, appStoreVersionInfo: appStoreVersion)
            messages.append(messageForApp)
        }

        let postMessage = messageRepository.generateMessage(messagesForApp: messages)
        let slackPostResult = try await slackRepository.post(to: channelID, message: postMessage, req: req)

        return PostAppStateToSlackDTO(
            appIDs: appIDs,
            channelID: slackPostResult.channel ?? "",
            postMessage: slackPostResult.message?.text ?? ""
        )
    }

    /// JWT を生成
    private func generateJWT() -> String? {
        if let token = token {
            print("Use created token again")
            req.logger.info("Use created token again")
            return token
        }

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
            token = try req.jwt.sign(payload, kid: keyID)
            print("Generate new token")
            req.logger.info("Generate new token")
            return token
        } catch {
            print("failed to generate jwt")
            req.logger.error("failed to generate jwt")
            return nil
        }
    }
}
