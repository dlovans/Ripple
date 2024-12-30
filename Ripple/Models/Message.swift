//
//  Message.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation

struct Message: Identifiable, Codable, Equatable {
    let id: String?
    let userId: String
    let username: String
    let message: String
    let isPremium: Bool
}
