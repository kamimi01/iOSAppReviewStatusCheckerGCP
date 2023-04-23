//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/24.
//

import Foundation

struct PostAppStateToSlackDTO {
    let appID: String
    let appName: String
    let version: String
    let createdDateString: String
    let appState: AppStoreState
    let appStateEmoji: String

    init(appID: String, appName: String, version: String, createdDate: Date, appState: AppStoreState, appStateEmoji: String) {
        self.appID = appID
        self.appName = appName
        self.version = version
        self.createdDateString = createdDate.stringFromDate(format: "yyyy/MM/dd HH:mm:ss")
        self.appState = appState
        self.appStateEmoji = appStateEmoji
    }
}
