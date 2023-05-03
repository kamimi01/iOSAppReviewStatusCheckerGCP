//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/26.
//

class MessageRepository {
    func generateMessageForApp(appInfo: AppInfo, appStoreVersionInfo: AppStoreVersionInfo) throws -> Message {
        return try Message(
            appName: appInfo.name,
            appVersion: appStoreVersionInfo.version,
            createdDate: appStoreVersionInfo.createdDate,
            state: appStoreVersionInfo.appStoreState
        )
    }

    func generateMessage(messagesForApp: [Message]) -> String {
        var message: String {
            var fullMessage = "iOS アプリのステータスをお知らせします 🍎"
            for messageForApp in messagesForApp {
                fullMessage += "\n\(messageForApp.text)"
            }
            return fullMessage
        }
        return message
    }
}
