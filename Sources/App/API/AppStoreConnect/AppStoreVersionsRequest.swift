//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/20.
//

import Foundation

struct AppStoreVersionsRequest: AppStoreConnectRequest {
    typealias Response = AppStoreVersions

    let method: HttpMethod = .get
    let path: String
    let token: String

    var headerFields: [String : String] {
        return ["Authorization": token]
    }

    var queryParameters: [String : String]? {
        var params: [String: String] = [
            "fields[appStoreVersions]": "appStoreState,versionString,createdDate",
            "limit": "1"
        ]

        return params
    }

    var body: Data? = nil

    init(appID: String, token: String) {
        self.path = "/apps/\(appID)/appStoreVersions"
        self.token = token
    }
}
