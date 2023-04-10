//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/28.
//

import Foundation

/// - seealso: https://developer.apple.com/documentation/appstoreconnectapi/list_review_submissions_for_an_app
struct GetAppSubmissionsRequest: AppStoreConnectRequest {
    typealias Response = ReviewSubmission

    let method: HttpMethod = .get
    let path = "/reviewSubmissions"
    let token: String

    var headerFields: [String : String] {
        return ["Authorization": token]
    }

    var queryParameters: [String : String]? {
        var params: [String: String] = [
            "filter[platform]": "IOS",
            "limit": "1"
        ]

        if let appId = appId {
            params["filter[app]"] = appId
        }

        return params
    }

    var body: Data? = nil

    let appId: String?

    init(appId: String?, token: String) {
        self.appId = appId
        self.token = token
    }
}
