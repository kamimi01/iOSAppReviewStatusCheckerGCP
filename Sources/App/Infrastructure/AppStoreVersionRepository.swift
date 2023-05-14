//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/23.
//

import Vapor

class AppStoreVersionRepository {
    // TODO: tokenは引数から無くして、このメソッドの内部で生成するようにしたい
    func fetch(id: String, token: String, req: Vapor.Request) async throws -> AppStoreVersionAndState {
        let request = AppStoreVersionsRequest(appID: id, token: token)
        let client = VaporAPIClient(req: req)
        let result = try await client.request(request)

        return try AppStoreVersionAndState(
            id: id,
            version: result.data.first?.attributes.versionString,
            createdDateString: result.data.first?.attributes.createdDate,
            appStoreStateString: result.data.first?.attributes.appStoreState
        )
    }
}
