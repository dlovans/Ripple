//
//  UserViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-19.
//

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = true
    @Published var userLoaded: Bool = false
    
    let userRepository = UserRepository()
    
    init() {
        if let isUser = Auth.auth().currentUser {
            Task { @MainActor in
                await self.createUser(userId: isUser.uid)
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.userLoaded = true
                }
            }
        } else {
            self.isLoading = false
            self.userLoaded = true
        }
    }
    
    func createUser(userId: String) async {
        Task { @MainActor in
            isLoading = true
            userLoaded = false
        }
        let newUser = await userRepository.createUser(userId: userId)
        Task { @MainActor in
            self.user = newUser
            self.isLoading = false
            self.userLoaded = true
        }
    }
    
    func destroyUserLocally() {
        self.user = nil
        self.userLoaded = false
    }
    
    func updateUsername(username: String) async {
        do {
            try await userRepository.updateUsername(userId: user?.id ?? "", username: username)
            Task { @MainActor in
                self.user?.username = username
            }
            print("Successfully updated username.")
        } catch {
            print("Failed to update username.")
        }
    }
}
