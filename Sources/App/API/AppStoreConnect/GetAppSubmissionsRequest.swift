//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/28.
//

import Foundation

/// - seealso: https://developer.apple.com/documentation/appstoreconnectapi/list_review_submissions_for_an_app
struct GetAppSubmissionsRequest: AppStoreConnectRequest {
    // TODO: Responseを実装したら以下を書き換える
//    typealias Response = <#T##Type#>

    let method: HttpMethod = .get
    let path = "/reviewSubmissions"

    var queryPaarameters: [String : String]? {
        var params: [String: String] = [
            "filter[platform]": "IOS",
            "limit": "1"
        ]

        if let appId = appId {
            params["filter[app]"] = appId
        }
    }

    let appId: String?

    init(appId: String?) {
        self.appId = appId
    }
}
