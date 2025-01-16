//
//  AuthRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-18.
//

import Foundation
import FirebaseAuth

class AuthRepository {
    func loginWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                let authError = NSError(domain: "AuthError", code: -1, userInfo: nil)
                completion(.failure(authError))
                return
            }
            
            completion(.success(authResult))
        }
    }
    
    func signupWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                let authError = NSError(domain: "AuthError", code: -1, userInfo: nil)
                completion(.failure(authError))
                return
            }
            
            completion(.success(authResult))
        }
    }
}

