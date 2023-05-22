//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/24.
//

import Vapor
import JWT

class PostAppStateToSlackUseCase {
    private let appRepository: AppRepository
    private let appStoreVersionRepository: AppStoreVersionRepository
    private let slackRepository: SlackRepository
    private let messageRepository: MessageRepository

    private var token: String?
    private let app: Application
    private let req: Vapor.Request

    init(appRepository: AppRepository = AppRepositoryImpl(), appStoreVersionRepository: AppStoreVersionRepository = AppStoreVersionRepositoryImpl(), slackRepository: SlackRepository = SlackRepositoryImpl(), messageRepository: MessageRepository = MessageRepositoryImpl(), app: Application, req: Vapor.Request) {
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

        var messages = [Message]()
        // ループの要素を並列に同時実行することで、API レスポンスを短くしている
        try await withThrowingTaskGroup(of: Message.self) { group in
            for appID in appIDs {
                group.addTask {
                    async let app = try self.appRepository.fetch(id: appID, token: jwt, req: self.req)
                    async let appStoreVersion = try self.appStoreVersionRepository.fetch(id: appID, token: jwt, req: self.req)

                    return try await self.messageRepository.generateMessageForApp(appInfo: app, appStoreVersionInfo: appStoreVersion)
                }
            }
            messages = try await group.reduce(into: [Message]()) { $0.append($1) }
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
    // TODO: JWTをメモリキャッシュして再利用するようにしたい
    private func generateJWT() -> String? {
        guard let issuerID = Environment.get("ISSUER_ID"),
              let privateKey = Environment.get("PRIVATE_KEY"),
              let keyIDString = Environment.get("KEY_ID")
        else { return nil }

        let keyID = JWKIdentifier(string: keyIDString)

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
            req.logger.info("Generate new token")
            return token
        } catch {
            req.logger.error("failed to generate jwt")
            return nil
        }
    }
}
