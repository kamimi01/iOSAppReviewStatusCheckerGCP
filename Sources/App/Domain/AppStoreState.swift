//
//  File.swift
//  
//
//  Created by mikaurakawa on 2023/04/12.
//

enum AppStoreState: String {
    case developerRemovedFromSale = "DEVELOPER_REMOVED_FROM_SALE"
    case developerRejected = "DEVELOPER_REJECTED"
    case inReview = "IN_REVIEW"
    case invalidBinary = "INVALID_BINARY"
    case metadataRejected = "METADATA_REJECTED"
    case pendingAppleRelease = "PENDING_APPLE_RELEASE"
    case pendingContract = "PENDING_CONTRACT"
    case pendingDeveloperRelease = "PENDING_DEVELOPER_RELEASE"
    case prepareForSubmission = "PREPARE_FOR_SUBMISSION"
    case preorderReadyForSale = "PREORDER_READY_FOR_SALE"
    case processingForAppStore = "PROCESSING_FOR_APP_STORE"
    case readyForSale = "READY_FOR_SALE"
    case rejected = "REJECTED"
    case removedFromSale = "REMOVED_FROM_SALE"
    case waitingForExportCompliance = "WAITING_FOR_EXPORT_COMPLIANCE"
    case waitingForReview = "WAITING_FOR_REVIEW"
    case replacedWithNewVersion = "REPLACED_WITH_NEW_VERSION"
    case accepted = "ACCEPTED"
    case readyForReview = "READY_FOR_REVIEW"

    var display: String {
        switch self {
        case .developerRemovedFromSale: return "開発者による販売停止"
        case .developerRejected: return "開発者による拒否"
        case .inReview: return "審査中"
        case .invalidBinary: return "無効なバイナリ"
        case .metadataRejected: return "メタデータに問題あり"
        case .pendingAppleRelease: return "Appleのリリース待ち"
        case .pendingContract: return "契約待ち"
        case .pendingDeveloperRelease: return "開発者のリリース待ち"
        case .prepareForSubmission: return "提出準備中"
        case .preorderReadyForSale: return "販売開始準備完了（予約注文受付中"
        case .processingForAppStore: return "App Storeで処理中"
        case .readyForSale: return "販売準備完了"
        case .rejected: return "拒否"
        case .removedFromSale: return "販売終了"
        case .waitingForExportCompliance: return "輸出規制待ち"
        case .waitingForReview: return "審査待ち"
        case .replacedWithNewVersion: return "新しいバージョンに置き換えられました"
        case .accepted: return "承認済み"
        case .readyForReview: return "審査待ち準備完了"
        }
    }

    var emoji: String {
        switch self {
        case .developerRemovedFromSale: return "🚫👨‍💻💰"
        case .developerRejected: return "❌👨‍💻"
        case .inReview: return "🕵️‍♂️🔍"
        case .invalidBinary: return "🚫💾"
        case .metadataRejected: return "❌📄"
        case .pendingAppleRelease: return "⏳🍎🆕"
        case .pendingContract: return "⏳📜"
        case .pendingDeveloperRelease: return "⏳👨‍💻🆕"
        case .prepareForSubmission: return "📝🔜"
        case .preorderReadyForSale: return "🛍️👀🆕"
        case .processingForAppStore: return "⚙️🛠️🏭"
        case .readyForSale: return "👌💰"
        case .rejected: return "❌"
        case .removedFromSale: return "🚫💰"
        case .waitingForExportCompliance: return "⏳📤✅"
        case .waitingForReview: return "⏳🕵️‍♂️"
        case .replacedWithNewVersion: return "🔁🆕"
        case .accepted: return "✅"
        case .readyForReview: return "✅🕵️‍♂️"
        }
    }
}
