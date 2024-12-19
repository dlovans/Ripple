//
//  AuthViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-17.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    let authRepository = AuthRepository()
    var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }
    
    func loginWithEmailAndPassword(email: String, password: String) {
        authRepository.loginWithEmailAndPassword(email: email, password: password) { result in
            switch (result) {
            case .success:
                print("Successfully signed in.")
            case .failure:
                print("Failed to sign in.")
            }
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
