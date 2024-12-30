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
    
    func fetchChat(chatId: String, onUpdate: @escaping (Chat?) -> Void) -> ListenerRegistration? {
        let listener = db.collection("chats").document(chatId).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Failed listening to chat: \(error.localizedDescription)")
                onUpdate(nil)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("Error fetching chat snapshot: Snapshot is nil.")
                onUpdate(nil)
                return
            }
            
            guard let data = querySnapshot.data() else {
                print("No data found for chat with ID: \(chatId)")
                onUpdate(nil)
                return
            }
            
            let chat = Chat(
                id: querySnapshot.documentID,
                chatName: data["chatName"] as? String ?? "Unnamed Chat",
                connections: data["connections"] as? Int ?? 1,
                maxConnections: data["maxConnections"] as? Int ?? 100,
                longStart: data["longStart"] as? Double ?? 0.0,
                longEnd: data["longEnd"] as? Double ?? 0.0,
                latStart: data["latStart"] as? Double ?? 0.0,
                latEnd: data["latEnd"] as? Double ?? 0.0
            )
            
            onUpdate(chat)
        }
        return listener
    }
    
    func incrementConnection(chatId: String) async throws {
        try await db.collection("chats").document(chatId).updateData(["connections": FieldValue.increment(Int64(1))])
    }
    
    func decrementConnection(chatId: String) async throws {
        try await db.collection("chats").document(chatId).updateData(["connections": FieldValue.increment(-Int64(1))])
    }
    
    
    func createChat(chatName: String, zoneSize: ZoneSize, location: Coordinate, maxConnections: Int) async -> String? {
        let geoData = calculateBoundingBox(center: location, zoneSize: zoneSize)
        let chatData: [String: Any] = [
            "chatName": chatName,
            "connections": 0,
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
            
            return chatRef.documentID
        } catch {
            print("Failed creating chat.")
            return nil
        }
    }
    
    func fetchChats(center: Coordinate, onUpdate: @escaping ([Chat]) -> Void) -> ListenerRegistration? {
        let geoData = calculateBoundingBox(center: center, zoneSize: .medium)
        print(geoData.latStart)
        print(geoData.latEnd)
        print(geoData.longStart)
        print(geoData.longEnd)
        print("test chats")
        
        let listener = db.collection("chats")
            .whereField("longStart", isLessThanOrEqualTo: center.longitude)
            .whereField("longEnd", isGreaterThanOrEqualTo: center.longitude)
            .whereField("latStart", isLessThanOrEqualTo: center.latitude)
            .whereField("latEnd", isGreaterThanOrEqualTo: center.latitude)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error listening to chats: \(error.localizedDescription)")
                    onUpdate([])
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("Empty chat snapshot.")
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
}
