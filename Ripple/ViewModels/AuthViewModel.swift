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
    
    func signupWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        authRepository.signupWithEmailAndPassword(email: email, password: password) { result in
            switch (result) {
            case .success(let authResult):
                print("Successfully signed up.")
                completion(.success(authResult))
            case .failure(let error):
                print("Failed to sign up.")
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
