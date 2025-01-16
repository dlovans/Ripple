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
    
    func blockUser(user userId: String, blocks blockUserId: String) async -> ReportAndBlockStatus {
        do {
            let userDocument = try await db.collection("users").document(userId).getDocument()
            
            if let blockedUsers = userDocument.data()?["blockedUsers"] as? [String] {
                if blockedUsers.contains(blockUserId) {
                    return .alreadyBlocked
                }
            }
            
            try await db.collection("users").document(userId).updateData(["blockedUserIds": FieldValue.arrayUnion([blockUserId])] )
            return .blockSuccess
        } catch {
            print("Failed to block user.")
            return .blockFailure
        }
    }
    
    func unblockUser(blocking userId: String, unblocking blockedUserId: String) async -> ReportAndBlockStatus {
        do {
            try await db.collection("users").document(userId).updateData(["blockedUserIds": FieldValue.arrayRemove([blockedUserId])])
            return .unblockSuccess
        } catch {
            print("Failed to unblock user.")
            return .blockFailure
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
    
    func getBlockedUsernames(blockedUserIds: [String]) async -> [String: String] {
        var usernames: [String: String] = [:]
        do {
            for userId in blockedUserIds {
                let docRef = db.collection("users").document(userId)
                let document = try await docRef.getDocument()
                
                if document.exists {
                    let username = document.data()?["username"] as? String ?? ""
                    usernames[userId] = username
                }
            }
            return usernames
        } catch {
            print("Failed to fetch blocked users' usernames!")
            return usernames
        }
    }
    
    func usernameAvailable(username: String) async -> UsernameStatus {
        do {
            let documents = try await db.collection("users")
                .whereField("username", isEqualTo: username)
                .limit(to: 1)
                .getDocuments()
            
            if documents.isEmpty {
                return .available
            } else {
                return .unavailable
            }
        } catch {
            print("Failed to check if username is available.")
            return .failure
        }
    }
    
    
    func updateUsername(userId: String, username: String) async -> UsernameStatus {
        let docRef = db.collection("users").document(userId)
        
        do {
            let isUsernameAvailable = await self.usernameAvailable(username: username)
            
            if isUsernameAvailable != .available {
                return isUsernameAvailable
            }
            
            try await docRef.updateData([
                "username": username
            ])
            
            return .success
        } catch {
            print("Failed to update username")
            return .failure
        }
    }
}
