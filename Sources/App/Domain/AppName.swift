//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/23.
//

import Vapor

protocol AppRepository {
    func fetch(id: String, token: String, req: Vapor.Request) async throws -> AppName
}

struct AppName {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
