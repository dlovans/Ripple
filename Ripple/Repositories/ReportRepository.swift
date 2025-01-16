//
//  ReportRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-09.
//

import Foundation
import FirebaseFirestore

class ReportRepository {
    let db = Firestore.firestore()

    func createMessageReport(chatId: String, messageId: String, againstUserId: String, byUserId: String, reportContent: String, reportType: ReportType) async -> ReportAndBlockStatus {
        let report: [String: Any] = [
            "chatId": chatId,
            "messageId": messageId,
            "againstUserId": againstUserId,
            "byUserId": byUserId,
            "reportContent": reportContent,
            "reportType": reportType.rawValue
        ]
        
        do {
            try await db.collection("reports").addDocument(data: report)
            return .reportSuccess
        } catch {
            print("Failed to create message report: \(error).")
            return .reportFailure
        }
    }
    
    func createChatReport(chatId: String, chatCreatedById: String, reportById: String, reportContent: String, reportType: ReportType) async -> ReportAndBlockStatus {
        let report: [String: Any] = [
            "chatId": chatId,
            "chatCreatedById": chatCreatedById,
            "reportById": reportById,
            "reportContent": reportContent,
            "reportType": reportType.rawValue
        ]
        
        do {
            try await db.collection("reports").addDocument(data: report)
            return .reportSuccess
        } catch {
            print("Failed to create chat report: \(error).")
            return .reportFailure
        }
    }
}
