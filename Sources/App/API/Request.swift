//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/29.
//

import Foundation

protocol Request {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var path: String { get }
    var headerFields: [String: String] { get }
    var queryParameters: [String: String]? { get }
    var body: Data? { get }
}
