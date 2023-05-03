//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/20.
//

struct Apps: Decodable {
    let data: [App]
}

struct App: Decodable {
    let id: String
    let attributes: AppAttributes
}

struct AppAttributes: Decodable {
    let name: String
}
