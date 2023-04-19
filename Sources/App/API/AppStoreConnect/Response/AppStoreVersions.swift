//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/20.
//

import Foundation

struct AppStoreVersions: Decodable {
    let data: [AppStoreVersion]
}

struct AppStoreVersion: Decodable {
    let attributes: AppStoreVersionAttributes
}

struct AppStoreVersionAttributes: Decodable {
    let versionString: String
    let appStoreState: String
}
