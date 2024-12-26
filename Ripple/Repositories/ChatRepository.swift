//
//  ChatRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class ChatRepository {
    let db = Firestore.firestore()
        
    func createChat(chatName: String, zoneSize: ZoneSize, location: Coordinate, maxConnections: Int) async -> Chat? {
        let geoData = calculateBoundingBox(center: location, zoneSize: zoneSize)
        let chatData: [String: Any] = [
            "name": chatName,
            "connections": 1,
            "maxConnection": maxConnections,
            "timestamp": FieldValue.serverTimestamp(),
            "longStart": geoData.longStart,
            "longEnd": geoData.longEnd,
            "latStart": geoData.latStart,
            "latEnd": geoData.latEnd
        ]
        
        do {
            let chatRef = try await db.collection("chats").addDocument(data: chatData)
            
            struct Message: Identifiable, Codable {
                let id: String?
                let userId: String?
                let username: String
                let message: String
                let isMe: Bool
                let isPremium: Bool
            }

            try await chatRef.collection("messages").addDocument(data: [
                "userId": "system",
                "username": "Admin",
                "timestamp": FieldValue.serverTimestamp(),
                "message": "Welcome...Keep it civil.",
                "isPremium": true
            ])
            
            return Chat(
                id: chatRef.documentID,
                chatName: chatName,
                connections: 1,
                maxConnections: maxConnections,
                longStart: geoData.longStart,
                longEnd: geoData.longEnd,
                latStart: geoData.latStart,
                latEnd: geoData.latEnd
            )
        } catch {
            print("Failed creating chat.")
            return nil
        }
    }
    
    func calculateBoundingBox(center: Coordinate, zoneSize: ZoneSize) -> (latStart: Double, latEnd: Double, longStart: Double, longEnd: Double) {
        let distance: Double
        switch zoneSize {
        case .small:
            distance = 3.0
        case .medium:
            distance = 5.0
        case .large:
            distance = 10.0
        case .extraLarge:
            distance = 15.0
        }

        let deltaLat = distance / 111.0
        let deltaLong = distance / (111.0 * cos(center.latitude * .pi / 180.0))

        let latStart = center.latitude - deltaLat
        let latEnd = center.latitude + deltaLat
        let longStart = center.longitude - deltaLong
        let longEnd = center.longitude + deltaLong

        return (latStart, latEnd, longStart, longEnd)
    }

}
