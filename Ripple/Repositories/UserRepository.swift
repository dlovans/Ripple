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
    private var userListener: ListenerRegistration? = nil
    
    func attachUserListener(userId: String, completion: @escaping (User?) -> Void) {
        let docRef = db.collection("users").document(userId)
        
        userListener = docRef.addSnapshotListener { [weak self] snapshot, err  in
            guard let self = self else { return }
            print(self)
            
            if let err {
                print("An error occurred while fetching user data: \(err)")
                completion(nil)
                return
            }
            
            guard let snapshot else {
                print("Empty snapshot")
                completion(nil)
                return
            }
            
            
            let user = User(
                id: snapshot.documentID,
                username: snapshot["username"] as? String ?? "",
                isPremium: snapshot["isPremium"] as? Bool ?? false,
                isBanned: snapshot["isBanned"] as? Bool ?? false,
                banLiftDate: (snapshot["banLiftDate"] as? Timestamp)?.dateValue() ?? nil,
                banMessage: snapshot["banMessage"] as? String ?? "",
                blockedUserIds: snapshot["blockedUserIds"] as? [String] ?? []
            )
            
            print(user.blockedUserIds)
            completion(user)
        }
    }
    
    func destroyUserListener() {
        userListener?.remove()
        userListener = nil
    }
    
    func updateUsername(userId: String, username: String) async throws {
        let docRef = db.collection("users").document(userId)
        
        try await docRef.updateData([
            "username": username
        ])
    }
    
    func blockUser(user userId: String, blocks blockUserId: String) async -> ReportAndBlockStatus {
        do {
            let userDocument = try await db.collection("users").document(userId).getDocument()
            
            if let blockedUsers = userDocument.data()?["blockedUsers"] as? [String] {
                if blockedUsers.contains(blockUserId) {
                    return .alreadyblocked
                }
            }
            
            try await db.collection("users").document(userId).updateData(["blockedUserIds": FieldValue.arrayUnion([blockUserId])] )
            return .blocksuccess
        } catch {
            print("Failed to block user.")
            return .blockfailed
        }
    }
    
    func unblockUser(blocking userId: String, unblocking blockedUserId: String) async -> ReportAndBlockStatus {
        do {
            try await db.collection("users").document(userId).updateData(["blockedUserIds": FieldValue.arrayRemove([blockedUserId])])
            return .unblocksuccess
        } catch {
            print("Failed to unblock user.")
            return .blockfailed
        }
    }
    
    func createUserInFirestore(userId: String) async {
        let docRef = db.collection("users").document(userId)
        
        do {
            let document = try await docRef.getDocument()
            
            if document.exists {
                return
            }
            
            try await db.collection("users").document(userId).setData([
                "username": "",
                "blockedUsers": [],
                "isPremium": false,
                "isBanned": false
            ])
        } catch {
            print("Failed to create user in firestore")
        }
        
    }
}
