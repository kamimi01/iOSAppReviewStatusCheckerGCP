//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/28.
//

import Foundation

protocol AppStoreConnectRequest: Request {}

extension AppStoreConnectRequest {
    var baseURL: URL {
        return URL(string: "https://api.appstoreconnect.apple.com/v1")!
    }
}
