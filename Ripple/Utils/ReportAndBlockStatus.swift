//
//  ReportStatus.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-11.
//

import Foundation

enum ReportAndBlockStatus: String, Codable {
    case
    reportfailed = "Failed to report user",
    reportsuccess = "User reported successfully",
    blockfailed = "Failed to block user",
    blocksuccess = "User blocked successfully",
    unblocksuccess = "User unblocked successfully",
    unblockfailed = "Failed to unblock user",
    alreadyblocked = "User is already blocked"
}
