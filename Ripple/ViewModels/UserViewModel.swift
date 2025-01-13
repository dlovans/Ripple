//
//  UserViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-19.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = true
    @Published var userLoaded: Bool = false
    
    let userRepository = UserRepository()
    
    init() {
        if let isUser = Auth.auth().currentUser {
            Task { @MainActor in
                userRepository.attachUserListener(userId: isUser.uid) { [weak self] user in
                    if let user {
                        self?.user = user
                        self?.isLoading = false
                        self?.userLoaded = true
                    }
                }
            }
        } else {
            self.isLoading = false
            self.userLoaded = true
        }
    }
    
    func attachUserListener() {
        userRepository.attachUserListener(userId: Auth.auth().currentUser?.uid ?? "") { [weak self] user in
            if let user {
                self?.user = user
                self?.isLoading = false
                self?.userLoaded = true
            }
        }
    }
    
    func createUserOnSignup() async {
        await userRepository.createUserInFirestore(userId: Auth.auth().currentUser?.uid ?? "")
    }
    
    func destroyUser() {
        userRepository.destroyUserListener()
        self.user = nil
        self.userLoaded = false
    }
    
    func updateUsername(username: String) async -> Bool {
        do {
            try await userRepository.updateUsername(userId: user?.id ?? "", username: username)
            print("Successfully updated username.")
            return true
        } catch {
            print("Failed to update username.")
            return false
        }
    }
    
    
    func blockUser(userId: String, blockingUserId: String) async -> ReportAndBlockStatus {
        return await userRepository.blockUser(user: userId, blocks: blockingUserId)
    }
    
    func unblockUser(userId: String, blockedUserId: String) async -> ReportAndBlockStatus {
        return await userRepository.unblockUser(blocking: userId, unblocking: blockedUserId)
    }
}
