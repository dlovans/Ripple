//
//  User.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-18.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var isPremium: Bool = false
    var isBanned: Bool = false
    var banLiftDate: Date?
    var banMessage: String = ""
    var blockedUserIds: [String] = []
}
