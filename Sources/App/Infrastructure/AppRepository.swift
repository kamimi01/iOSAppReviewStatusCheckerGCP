//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/23.
//

import Foundation

enum AppStoreConnectRequestError: Error {
    case notFoundAppName
    case cannotGenerateJWT
}

class AppRepository {
    // TODO: tokenは引数から無くして、このメソッドの内部で生成するようにしたい
    func fetch(id: String, token: String) async throws -> AppInfo {
        let session = Session()
        let request = AppsRequest(token: token)
        let result = try await session.send(request)

        var name: String? {
            for app in result.data where app.id == id {
                return app.attributes.name
            }
            return nil
        }

        guard let name = name else {
            throw AppStoreConnectRequestError.notFoundAppName
        }

        return AppInfo(id: id, name: name)
    }
}
