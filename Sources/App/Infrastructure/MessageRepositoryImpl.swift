//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/26.
//

class MessageRepositoryImpl: MessageRepository {
    /// アプリごとの投稿メッセージを生成する
    func generateMessageForApp(appInfo: AppName, appStoreVersionInfo: AppStoreVersionAndState) throws -> Message {
        return try Message(
            appName: appInfo.name,
            appVersion: appStoreVersionInfo.version,
            createdDate: appStoreVersionInfo.createdDate,
            state: appStoreVersionInfo.appStoreState
        )
    }

    /// 投稿メッセージ全体を生成する
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
