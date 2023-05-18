//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/23.
//

import Vapor

enum AppStoreConnectRequestError: Error {
    case notFoundAppName
    case cannotGenerateJWT
}

class AppRepositoryImpl: AppRepository {
    private var cache: AppsRequest.Response?

    // TODO: tokenは引数から無くして、このメソッドの内部で生成するようにしたい
    func fetch(id: String, token: String, req: Vapor.Request) async throws -> AppName {
        
        var result: AppsRequest.Response?
        if let cache = cache {
            result = cache
            req.logger.info("use cache of apps request")
        } else {
            let request = AppsRequest(token: token)
            let client = VaporAPIClient(req: req)
            result = try await client.request(request)
            cache = result
            req.logger.info("dont use cache and request apps")
        }

        var name: String? {
            guard let result = result else { return nil }

            for app in result.data where app.id == id {
                return app.attributes.name
            }
            return nil
        }

        guard let name = name else {
            throw AppStoreConnectRequestError.notFoundAppName
        }

        return AppName(id: id, name: name)
    }
}
