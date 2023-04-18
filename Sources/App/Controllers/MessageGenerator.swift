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
    func generatePostMessage(appID: String, submittedDate: String?, state: String?) throws -> String {
        guard let submittedDate = submittedDate,
              let state = state else {
            throw MessageGenerateError.requiredParametersAreNil((submittedDate, state))
        }

        guard let convertedSubmittedDate = submittedDate.dateFromString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
              let reviewState = ReviewState(rawValue: state)
        else { throw MessageGenerateError.falidToConvertDate(submittedDate) }

        let stringSubmittedDate = convertedSubmittedDate.stringFromDate(format: "yyyy/MM/dd HH:mm:ss")

        let message = """
        iOS アプリの審査状況をお知らせします🍎

        【TopicGen】
        提出日時：\(stringSubmittedDate)
        審査ステータス：\(reviewState.display) \(reviewState.emoji)
        """

        return message
    }
}
