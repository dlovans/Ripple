//
//  Chat.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation

struct Chat: Identifiable, Codable {
    var id: String
    var chatName: String = "Abyss"
    var connections: Int
}
