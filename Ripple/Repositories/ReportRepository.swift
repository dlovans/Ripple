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
            return .reportsuccess
        } catch {
            print("Failed to create report: \(error).")
            return .reportfailed
        }
    }
}
