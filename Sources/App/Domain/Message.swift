//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/26.
//

import Foundation

protocol MessageRepository {
    func generateMessageForApp(appInfo: AppName, appStoreVersionInfo: AppStoreVersionAndState) throws -> Message
    func generateMessage(messagesForApp: [Message]) -> String
}

enum MessageGenerateError: Error {
    case requiredParametersAreNil((appName: String?, appVersion: String?, createdDate: Date?, state: AppStoreState?))
}

struct Message {
    let text: String

    init(appName: String?, appVersion: String?, createdDate: Date?, state: AppStoreState?) throws {
        guard let appName = appName,
              let appVersion = appVersion,
              let createdDate = createdDate,
              let state = state
        else { throw MessageGenerateError.requiredParametersAreNil((appName, appVersion, createdDate, state)) }

        let formattedCreatedDateString = createdDate.stringFromDate(format: "yyyy/MM/dd HH:mm:ss")

        let message = """
        【\(appName)】
        バージョン：\(appVersion)
        ステータス：\(state.display)（\(state.rawValue)） \(state.emoji)
        作成日時：\(formattedCreatedDateString)
        \n
        """

        self.text = message
    }
}
