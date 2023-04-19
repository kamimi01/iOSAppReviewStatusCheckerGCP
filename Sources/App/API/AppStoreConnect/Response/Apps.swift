//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/20.
//

import Foundation

struct Apps: Decodable {
    let data: [App]
}

struct App: Decodable {
    let id: String
    let attributes: AppAttributes
    let relationships: AppRelationships
}

struct AppAttributes: Decodable {
    let name: String
}

struct AppRelationships: Decodable {
    let appStoreVersions: AppStoreVersions
}

struct AppStoreVersions: Decodable {
    let links: AppStoreVersionsLinks
}

struct AppStoreVersionsLinks: Decodable {
    let related: URL?

    init(related: String) {
        self.related = URL(string: related)
    }
}
