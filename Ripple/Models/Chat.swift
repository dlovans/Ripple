//
//  Chat.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation

struct Chat: Identifiable, Codable {
    let id: String
    let chatName: String
    let connections: Int
    let maxConnections: Int
    let longStart: Double
    let longEnd: Double
    let latStart: Double
    let latEnd: Double
}
