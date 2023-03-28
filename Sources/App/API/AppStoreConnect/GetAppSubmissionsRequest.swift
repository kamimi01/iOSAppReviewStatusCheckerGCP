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

    var headerFields: [String : String] {
        return ["Authorization": "<JWT>"]
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

    let appId: String?

    init(appId: String?) {
        self.appId = appId
    }
}