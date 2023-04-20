//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/19.
//

import Foundation

enum MessageGenerateError: Error {
    case requiredParametersAreNil((submittedDate: String?, state: String?))
    case falidToConvertDate(String)
}

class MessageGenerator {
    func generatePostMessage(appName: String?, appVersion: String?,  createdDate: String?, state: String?) throws -> String {
        guard let appName = appName,
              let appVersion = appVersion,
              let submittedDate = createdDate,
              let state = state else {
            throw MessageGenerateError.requiredParametersAreNil((createdDate, state))
        }

        guard let convertedSubmittedDate = submittedDate.dateFromString(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ") else { throw MessageGenerateError.falidToConvertDate(submittedDate) }

        let appStoreState = AppStoreState(rawValue: state)

        let stringSubmittedDate = convertedSubmittedDate.stringFromDate(format: "yyyy/MM/dd HH:mm:ss")

        let message = """
        iOS アプリのステータスをお知らせします🍎

        【\(appName)】
        バージョン：\(appVersion)
        ステータス：\(appStoreState?.display ?? "不明なステータス")（\(appStoreState?.rawValue ?? "")） \(appStoreState?.emoji ?? "❓")
        作成日時：\(stringSubmittedDate)
        """

        return message
    }
}
