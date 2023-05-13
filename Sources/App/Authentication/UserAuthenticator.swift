//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/27.
//

import Vapor

class UserAuthenticator: AsyncBasicAuthenticator {
    func authenticate(basic: Vapor.BasicAuthorization, for request: Vapor.Request) async throws {
        if basic.username == Environment.get("USERNAME") && basic.password == Environment.get("PASSWORD") {
            request.auth.login(User(name: "Vapor"))
        }
    }
}
