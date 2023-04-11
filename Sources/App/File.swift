//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/12.
//

import Foundation

enum ReviewState: String {
    case readyForReview = "READY_FOR_REVIEW"
    case waitingForReview = "WAITING_FOR_REVIEW"
    case inReview = "IN_REVIEW"
    case unresolvedIssues = "UNRESOLVED_ISSUES"
    case canceling = "CANCELING"
    case completing = "COMPLETING"
    case complete = "COMPLETE"

    var display: String {
        switch self {
        case .readyForReview: return "審査準備完了"
        case .waitingForReview: return "審査待ち"
        case .inReview: return "審査中"
        case .unresolvedIssues: return "未解決の問題"
        case .canceling: return "キャンセル中"
        case .completing: return "完了予定"
        case .complete: return "完了"
        }
    }

    var emoji: String {
        switch self {
        case .readyForReview: return "📤"
        case .waitingForReview: return "🕒"
        case .inReview: return "🕵️‍♂️"
        case .unresolvedIssues: return "🚨"
        case .canceling: return "🛑"
        case .completing: return "🏁"
        case .complete: return "✅"
        }
    }
}
