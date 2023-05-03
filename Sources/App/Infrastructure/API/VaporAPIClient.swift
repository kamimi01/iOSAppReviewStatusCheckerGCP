//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/29.
//

import Vapor

/// Vapor の API を使って、API リクエストをする
final class VaporAPIClient {
    private let req: Vapor.Request

    init(req: Vapor.Request) {
        self.req = req
    }

    func request<T: Request>(_ request: T) async throws -> T.Response {
        var headers = HTTPHeaders()
        if request.headerFields.isEmpty == false {
            for header in request.headerFields {
                headers.add(name: header.key, value: header.value)
            }
        }

        switch request.method {
        case .get:
            let uri = URI(stringLiteral: request.baseURL.absoluteString + request.path)
            if let queryParameters = request.queryParameters {
                let response = try await req.client.get(uri, headers: headers) { req in
                    try req.query.encode(queryParameters)
                }
                return try response.content.decode(T.Response.self)
            } else {
                let response = try await req.client.get(uri, headers: headers)
                return try response.content.decode(T.Response.self)
            }
        case .post:
            let response = try await req.client.post(URI(stringLiteral: request.baseURL.absoluteString + request.path), headers: headers) { req in
                if let body = request.body as? [String: String] {
                    try req.content.encode(body)
                }
            }
            return try response.content.decode(T.Response.self)
        }
    }
}
