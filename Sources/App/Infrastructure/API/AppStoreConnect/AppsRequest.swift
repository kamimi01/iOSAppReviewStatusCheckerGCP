//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/20.
//

import Foundation

struct AppsRequest: AppStoreConnectRequest {
    typealias Response = Apps

    let method: HttpMethod = .get
    let path = "/apps"
    let token: String

    var headerFields: [String : String] {
        return ["Authorization": token]
    }

    var queryParameters: [String : String]? {
        let params: [String: String] = [
            "fields[apps]": "name"
        ]

        return params
    }

    var body: [String: Any]? = nil
}
