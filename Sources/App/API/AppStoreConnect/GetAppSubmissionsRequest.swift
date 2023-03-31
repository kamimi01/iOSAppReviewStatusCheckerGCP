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
        return ["Authorization": "eyJraWQiOiJKTlpDNDM0NVFOIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiI5NmQ4ZGIyYS02NDk2LTQyYjAtOTNjZi0zZjY4NGQxYzQyZmYiLCJleHAiOjE2ODAyNjk1MDksImF1ZCI6ImFwcHN0b3JlY29ubmVjdC12MSJ9.oCWAMHOzdrAQw4s8eF055404LtUGr2TOGkJg4mYpbTTo-DVCvh7QxIfyb1XXkwBQKRs7zm9L9Xo-45kEE93QuQ"]
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
