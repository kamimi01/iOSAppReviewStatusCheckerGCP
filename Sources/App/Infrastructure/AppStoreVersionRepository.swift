//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/23.
//

import Foundation

class AppStoreVersionRepository {
    // TODO: tokenは引数から無くして、このメソッドの内部で生成するようにしたい
    func fetch(id: String, token: String) async throws -> AppStoreVersionInfo {
        let session = Session()
        let request = AppStoreVersionsRequest(appID: id, token: token)
        let result = try await session.send(request)

        return try AppStoreVersionInfo(
            id: id,
            version: result.data.first?.attributes.versionString,
            createdDateString: result.data.first?.attributes.createdDate,
            appStoreStateString: result.data.first?.attributes.appStoreState
        )
    }
}
