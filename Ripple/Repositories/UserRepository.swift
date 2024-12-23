//
//  UserRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-19.
//

import Foundation
import FirebaseFirestore

class UserRepository {
    let db = Firestore.firestore()
    
    func createUser(userId: String) async -> User? {
        let docRef = db.collection("users").document(userId)
        
        do {
            let document = try await docRef.getDocument()
            
            if document.exists, let data = document.data() {
                if let username = data["username"] as? String,
                   let isPremium = data["isPremium"] as? Bool {
                    print("Fetched user data.")
                    return User(id: userId, username: username, isPremium: isPremium)
                } else {
                    print("Error: Missing or invalid fields in document.")
                    return nil
                }
            } else {
                try await db.collection("users").document(userId).setData([
                    "username": "",
                    "isPremium": false
                ])
                print("Created and fetched user data.")

                return User(id: userId, username: "", isPremium: false)
            }
        } catch {
            print("Error fetching user data: \(error)")
            return nil
        }
    }
    
    func updateUsername(userId: String, username: String) async throws {
        let docRef = db.collection("users").document(userId)
        
        try await docRef.updateData([
            "username": username
        ])
    }
    
}
