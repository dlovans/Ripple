//
//  ReportViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-09.
//

import Foundation

class ReportViewModel: ObservableObject {
    private let reportRepository: ReportRepository = ReportRepository()
    
    func createMessageReport(chatId: String, messageId: String, againstUserId: String, byUserId: String, reportContent: String, reportType: ReportType) async -> ReportAndBlockStatus {
        return await reportRepository.createMessageReport(chatId: chatId, messageId: messageId, againstUserId: againstUserId, byUserId: byUserId, reportContent: reportContent, reportType: reportType)
    }
    
    func createChatReport(chatId: String, chatCreatedById: String, reportById: String, reportContent: String, reportType: ReportType) async -> ReportAndBlockStatus {
        return await reportRepository.createChatReport(chatId: chatId, chatCreatedById: chatCreatedById, reportById: reportById, reportContent: reportContent, reportType: reportType)
    }
}
