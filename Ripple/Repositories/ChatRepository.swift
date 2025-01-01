//
//  ChatRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class ChatRepository {
    private let db = Firestore.firestore()
    
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
                latEnd: data["latEnd"] as? Double ?? 0.0,
                description: data["description"] as? String ?? ""
            )
            
            onUpdate(chat)
        }
        return listener
    }
    
    func updatePresence(chatId: String) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let presenceRef = db.collection("chats").document(chatId).collection("listeners").document(userId)
        
        do {
            try await presenceRef.setData([
                "lastActive": FieldValue.serverTimestamp()
            ], merge: true)
        } catch {
            print("Error manifesting presence: \(error.localizedDescription)")
        }
    }
    
    func deletePresence(chatId: String?) async {
        guard let chatId else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let presenceRef = db.collection("chats").document(chatId).collection("listeners").document(userId)
        
        do {
            try await presenceRef.delete()
        } catch {
            print("Error deleting presence: \(error.localizedDescription).")
        }
    }
    
    func incrementConnection(chatId: String) async throws {
        try await db.collection("chats").document(chatId).updateData(["connections": FieldValue.increment(Int64(1))])
    }
    
    func decrementConnection(chatId: String) async throws {
        try await db.collection("chats").document(chatId).updateData(["connections": FieldValue.increment(-Int64(1))])
    }
    
    
    func createChat(chatName: String, zoneSize: ZoneSize, location: Coordinate, maxConnections: Int, description: String) async -> String? {
        let geoData = calculateBoundingBox(center: location, zoneSize: zoneSize)
        let chatData: [String: Any] = [
            "chatName": chatName,
            "connections": 0,
            "maxConnections": maxConnections,
            "timestamp": FieldValue.serverTimestamp(),
            "longStart": geoData.longStart,
            "longEnd": geoData.longEnd,
            "latStart": geoData.latStart,
            "latEnd": geoData.latEnd,
            "description": description
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
                    let chat = Chat(
                        id: document.documentID,
                        chatName: document.data()["chatName"] as? String ?? "Unknown Chat",
                        connections: document.data()["connections"] as? Int ?? 0,
                        maxConnections: document.data()["maxConnections"] as? Int ?? 100,
                        longStart: document.data()["longStart"] as? Double ?? 0.0,
                        longEnd: document.data()["longEnd"] as? Double ?? 0.0,
                        latStart: document.data()["latStart"] as? Double ?? 0.0,
                        latEnd: document.data()["latEnd"] as? Double ?? 0.0,
                        description: document.data()["description"] as? String ?? ""
                    )
                    
                    chats.append(chat)
                }
                
                onUpdate(chats)
            }
        
        return listener
    }
}
