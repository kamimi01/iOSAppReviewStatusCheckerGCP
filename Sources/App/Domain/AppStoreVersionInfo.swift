//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/23.
//

import Foundation

enum AppStoreVersionError: Error {
    case failedToConvertStringToDate(String)
    case failedToConvertAppStoreState(String)
    case requiredParametersAreNil((version: String?, createdDateString: String?, appStoreStateString: String?))
}

struct AppStoreVersionInfo {
    let id: String
    let version: String
    let createdDate: Date
    let appStoreState: AppStoreState

    init(id: String, version: String?, createdDateString: String?, appStoreStateString: String?) throws {
        self.id = id

        guard let version = version,
              let createdDateString = createdDateString,
              let appStoreStateString = appStoreStateString
        else { throw AppStoreVersionError.requiredParametersAreNil((version, createdDateString, appStoreStateString)) }

        self.version = version
        guard let createdDate = createdDateString.dateFromString(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ") else {
            throw AppStoreVersionError.failedToConvertStringToDate(createdDateString)
        }
        self.createdDate = createdDate
        guard let appStoreState =  AppStoreState(rawValue: appStoreStateString) else {
            throw AppStoreVersionError.failedToConvertAppStoreState(appStoreStateString)
        }
        self.appStoreState = appStoreState
    }
}
