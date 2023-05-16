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

class AppRepositoryCache {
    static let shared = AppRepositoryCache()
    private init() {}

    typealias Cache = AppsRequest.Response
    private var cache: Cache?

    func fetch() -> Cache? {
        if let cache = cache {
            return cache
        }
        return nil
    }

    func set(_ cache: Cache) {
        self.cache = cache
    }
}

class AppRepositoryImpl: AppRepository {
    private var cache: AppsRequest.Response?

    // TODO: tokenは引数から無くして、このメソッドの内部で生成するようにしたい
    func fetch(id: String, token: String, req: Vapor.Request) async throws -> AppName {

        var result: AppsRequest.Response?
        if let cache = AppRepositoryCache.shared.fetch() {
            req.logger.info("exist cache of apps request")
            result = cache
        } else {
            req.logger.info("dont exist cache and request apps api")
            let request = AppsRequest(token: token)
            let client = VaporAPIClient(req: req)
            result = try await client.request(request)

            if let result = result {
                AppRepositoryCache.shared.set(result)
            }
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
