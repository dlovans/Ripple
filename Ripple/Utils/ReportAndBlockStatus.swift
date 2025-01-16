//
//  ReportStatus.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2025-01-11.
//

import Foundation

enum ReportAndBlockStatus: String, Codable {
    case
    reportFailure = "Failed to report user",
    reportSuccess = "User reported successfully",
    blockFailure = "Failed to block user",
    blockSuccess = "User blocked successfully",
    unblockSuccess = "User unblocked successfully",
    unblockFailure = "Failed to unblock user",
    alreadyBlocked = "User is already blocked"
}
