//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/19.
//

import Foundation
import Vapor
import JWT

enum AppStoreConnectRequestError: Error {
    case cannotGenerateJWT
    case notFoundAppName
}

/// App Store Connect へのリクエストを受け、レスポンスを返す責務
class AppStoreConnectController {
    private let app: Application
    private let req: Vapor.Request

    private var token: String? = nil

    init(app: Application, req: Vapor.Request) {
        self.app = app
        self.req = req
    }

    func requestApp(appID: String) async throws -> String? {
        guard let jwt = generateJWT() else { throw AppStoreConnectRequestError.cannotGenerateJWT }

        let session = Session()
        let request = AppsRequest(token: jwt)
        let result = try await session.send(request)

        var name: String? {
            for app in result.data where app.id == appID {
                return app.attributes.name
            }
            return nil
        }

        guard let name = name else {
            throw AppStoreConnectRequestError.notFoundAppName
        }

        return name
    }

    func requestAppStoreVersions(appID: String) async throws -> AppStoreVersionsRequest.Response {
        guard let jwt = generateJWT() else { throw AppStoreConnectRequestError.cannotGenerateJWT }

        let session = Session()
        let request = AppStoreVersionsRequest(appID: appID, token: jwt)
        let result = try await session.send(request)

        return result
    }

    /// JWT を生成
    private func generateJWT() -> String? {
        if let token = token {
            print("Use created token again")
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
            return token
        } catch {
            print("failed to generate jwt")
            return nil
        }
    }
}
