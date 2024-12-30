//
//  MessageViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-25.
//

import Foundation
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let messageRepository: MessageRepository = MessageRepository()
    
    private var messagesListener: ListenerRegistration?
    
    func subscribeToMessages(chatId: String) {
        messagesListener = messageRepository.getMessages(chatId: chatId) { [weak self] messages in
            Task { @MainActor in
                self?.messages = messages
            }
        }
    }
    
    func unsubscribeFromMessages() {
        messagesListener?.remove()
        messagesListener = nil
        self.messages.removeAll()
    }
    
    func addMessage(message: String, username: String, userId: String, isPremium: Bool, chatId: String) async {
        let messageStatus = await messageRepository.createMessage(message: message, username: username, userId: userId, isPremium: isPremium, chatId: chatId)
        
        if messageStatus {
            print("Successfully created a new message in DB.")
            
        } else {
            print("Failed to create a new message in DB.")
        }
    }
}
