//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/28.
//

import Foundation

protocol AppStoreConnectRequest {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var path: String { get }
    var headerFields: [String: String] { get }
    var queryPaarameters: [String: String]? { get }
}

extension AppStoreConnectRequest {
    var baseURL: URL {
        return URL(string: "https://api.appstoreconnect.apple.com/v1")!
    }
}
