//
//  Event.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-25.
//

import Foundation

struct Event: Identifiable, Codable {
    let id: String
    let category: String
    let title: String
    let description: String
    let imageURL: URL?
}
