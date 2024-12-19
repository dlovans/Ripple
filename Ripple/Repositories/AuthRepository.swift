//
//  AuthRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-18.
//

import Foundation
import FirebaseAuth

class AuthRepository {
    func loginWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
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
    
    /**
     Signs up user with email and password.
     - Parameters:
        - email: The email to sign up with.
        - password: User-inputted password.
        - completion: A closure called when the sign up process completes. It takes a Result type:
            - `.success(AuthDataResult)`: Contains the authentication result when the sign up is successful.
            - `.failure(Error)`: Contains the error that occurred if the sign up fails.
     */
    func signupWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
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

