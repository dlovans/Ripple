//
//  MessageViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-25.
//

import Foundation

class MessageViewModel: ObservableObject {
    private let messageRepository: MessageRepository = MessageRepository()
    
    func addMessage(message: String, username: String, userId: String, isPremium: Bool, chatId: String) async {
        let messageStatus = await messageRepository.createMessage(message: message, username: username, userId: userId, isPremium: isPremium, chatId: chatId)
        
        if messageStatus {
            print("Successfully created a new message in DB.")
        } else {
            print("Failed to create a new message in DB.")
        }
    }
}
