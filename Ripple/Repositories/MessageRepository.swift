//
//  MessageRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-25.
//

import Foundation
import FirebaseFirestore

class MessageRepository {
    let db = Firestore.firestore()
    func createMessage(message: String, username: String, userId: String, isPremium: Bool, chatId: String) async -> Bool {
        let chatRef = db.collection("chats").document(chatId).collection("messages")
        
        let messageData: [String: Any] = [
            "message": message,
            "username": username,
            "userId": userId,
            "isPremium": isPremium,
            "timestamp": FieldValue.serverTimestamp()
        ]
            
        
        do {
            try await chatRef.addDocument(data: messageData)
            return true
        } catch {
            return false
        }
    }
}
