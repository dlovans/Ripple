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
            "chatName": chatName,
            "connections": 1,
            "maxConnections": maxConnections,
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
    
    func fetchChats(center: Coordinate, onUpdate: @escaping ([Chat]) -> Void) -> ListenerRegistration? {
        let geoData = calculateBoundingBox(center: center, zoneSize: .medium)

        let listener = db.collection("chats")
            .whereField("longStart", isGreaterThanOrEqualTo: geoData.longStart)
            .whereField("longEnd", isLessThanOrEqualTo: geoData.longEnd)
            .whereField("latStart", isGreaterThanOrEqualTo: geoData.latStart)
            .whereField("latEnd", isLessThanOrEqualTo: geoData.latEnd)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error listening to chats: \(error.localizedDescription)")
                    onUpdate([])
                    return
                }

                guard let querySnapshot = querySnapshot else {
                    onUpdate([])
                    return
                }

                var chats: [Chat] = []
                for document in querySnapshot.documents {
                    let chatName = document.data()["chatName"] as? String ?? "Unknown Chat"
                    let connections = document.data()["connections"] as? Int ?? 0
                    let maxConnections = document.data()["maxConnections"] as? Int ?? 100
                    let longStart = document.data()["longStart"] as? Double ?? 0.0
                    let longEnd = document.data()["longEnd"] as? Double ?? 0.0
                    let latStart = document.data()["latStart"] as? Double ?? 0.0
                    let latEnd = document.data()["latEnd"] as? Double ?? 0.0

                    let chat = Chat(
                        id: document.documentID,
                        chatName: chatName,
                        connections: connections,
                        maxConnections: maxConnections,
                        longStart: longStart,
                        longEnd: longEnd,
                        latStart: latStart,
                        latEnd: latEnd
                    )
                    chats.append(chat)
                }

                onUpdate(chats)
            }

        return listener
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
