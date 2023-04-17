//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/03/29.
//

import Foundation

enum SessionError: Error {
    case noResponse
    case unacceptableStatusCode(Int, Message?)
    case failedToCreateComponents(URL)
    case failedToCreateURL(URLComponents)
    case failedToDecode(Error)
}

final class Session {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<T: Request>(_ request: T) async throws -> T.Response {
        let url = request.baseURL.appendingPathComponent(request.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw SessionError.failedToCreateComponents(url)
        }
        components.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)

        guard var urlRequest = components.url.map({ URLRequest(url: $0) }) else {
            throw SessionError.failedToCreateURL(components)
        }

        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headerFields
        if let body = request.body {
            urlRequest.httpBody = body
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw SessionError.noResponse
        }

        guard 200..<300 ~= response.statusCode else {
            let message = try? JSONDecoder().decode(SessionError.Message.self, from: data)
            throw SessionError.unacceptableStatusCode(response.statusCode, message)
        }

        do {
            let object = try JSONDecoder().decode(T.Response.self, from: data)
            return object
        } catch {
            throw SessionError.failedToDecode(error)
        }
    }
}

extension SessionError {
    struct Message: Decodable {
        let message: String
    }
}
