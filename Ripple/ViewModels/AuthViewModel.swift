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
    var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }
    
    
}
