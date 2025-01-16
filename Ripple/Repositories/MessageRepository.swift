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
    
    func getMessages(chatId: String, blockedUserIds: [String], onUpdate: @escaping ([Message]) -> Void) -> ListenerRegistration? {
        let messagesRef = db.collection("chats").document(chatId).collection("messages")
        print(blockedUserIds)
        let listener = messagesRef
            .order(by: "timestamp")
            .limit(to: 20)
            .addSnapshotListener { querySnapshot, error in
                
                if let error {
                    print("Failed to retrieve messages: \(error.localizedDescription)")
                    onUpdate([])
                    return
                }
                
                guard let querySnapshot else {
                    print("Error fetching messages snapshot: Snapshot is nil.")
                    onUpdate([])
                    return
                }
                
                let messages = querySnapshot.documents
                    .filter { !blockedUserIds.contains($0.data()["userId"] as? String ?? "Unknown")}
                    .map { QueryDocumentSnapshot in
                        if let timestamp = QueryDocumentSnapshot.data()["timestamp"] as? Timestamp {
                            let date = timestamp.dateValue()
                            let hourMinute = Calendar.current.dateComponents([.hour, .minute], from: date)
                            
                            let hour = hourMinute.hour.map { $0 < 10 ? "0\($0)" : "\($0)" } ?? ""
                            let minute = hourMinute.minute.map { $0 < 10 ? "0\($0)" : "\($0)" } ?? ""
                            
                            return Message(
                                id: QueryDocumentSnapshot.documentID,
                                userId: QueryDocumentSnapshot.data()["userId"] as? String ?? "Unknown",
                                username: QueryDocumentSnapshot.data()["username"] as? String ?? "Unknown",
                                message: QueryDocumentSnapshot.data()["message"] as? String ?? "Unknown",
                                isPremium: QueryDocumentSnapshot.data()["isPremium"] as? Bool ?? false,
                                createdAt: "\(hour):\(minute)"
                            )
                        } else {
                            return Message(
                                id: QueryDocumentSnapshot.documentID,
                                userId: QueryDocumentSnapshot.data()["userId"] as? String ?? "Unknown",
                                username: QueryDocumentSnapshot.data()["username"] as? String ?? "Unknown",
                                message: QueryDocumentSnapshot.data()["message"] as? String ?? "Unknown",
                                isPremium: QueryDocumentSnapshot.data()["isPremium"] as? Bool ?? false,
                                createdAt: ""
                            )
                        }

                    }
                
                onUpdate(messages)
            }
        return listener
    }
    
    func createMessage(message: String, username: String, userId: String, isPremium: Bool, chatId: String) async -> Bool {
        let messagesRef = db.collection("chats").document(chatId).collection("messages")
        let chatRef = db.collection("chats").document(chatId)
        
        let messageData: [String: Any] = [
            "message": message,
            "username": username,
            "userId": userId,
            "isPremium": isPremium,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        
        do {
            try await messagesRef.addDocument(data: messageData)
            try await chatRef.updateData([
                "lastActive": FieldValue.serverTimestamp()
            ])
            return true
        } catch {
            return false
        }
    }
}
