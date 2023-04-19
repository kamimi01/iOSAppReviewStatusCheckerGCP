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
}

/// App Store Connect へのリクエストを受け、レスポンスを返す責務
class AppStoreConnectController {
    private let app: Application
    private let req: Vapor.Request
    private let appIDs: [String]

    init(app: Application, req: Vapor.Request, appIDs: [String]) {
        self.app = app
        self.req = req
        self.appIDs = appIDs
    }

    func requestReviewSubmission() async throws -> GetAppSubmissionsRequest.Response {
        guard let jwt = generateJWT() else { throw AppStoreConnectRequestError.cannotGenerateJWT }

        let session = Session()
        let request = GetAppSubmissionsRequest(appId: appIDs.first, token: jwt)
        let result = try await session.send(request)

        return result
    }

    func requestApps() async throws -> AppsRequest.Response {
        guard let jwt = generateJWT() else { throw AppStoreConnectRequestError.cannotGenerateJWT }

        let session = Session()
        let request = AppsRequest(token: jwt)
        let result = try await session.send(request)

        return result
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
            return token
        } catch {
            print("failed to generate jwt")
            return nil
        }
    }
}
