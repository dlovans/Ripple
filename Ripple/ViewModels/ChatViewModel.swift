//
//  ChatViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var chat: Chat? = nil
    
    let chatRepository: ChatRepository = ChatRepository()
    
    func addMessage(message: String, username: String, userId: String, isPremium: Bool, chatId: String) async {
        let messageStatus = await chatRepository.createMessage(message: message, username: username, userId: userId, isPremium: isPremium, chatId: chatId)
        
        if messageStatus {
            print("Successfully created a new message in DB.")
        } else {
            print("Failed to create a new message in DB.")
        }
    }
}
