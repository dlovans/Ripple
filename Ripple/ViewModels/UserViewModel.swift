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
    
    let userRepository = UserRepository()
    
    init() {
        if let user = Auth.auth().currentUser {
            Task {
                await self.createUser(userId: user.uid)
            }
        }
    }
    
    func createUser(userId: String) async {
        let newUser = await userRepository.createUser(userId: userId)
        Task { @MainActor in
            self.user = newUser
        }
    }
}
