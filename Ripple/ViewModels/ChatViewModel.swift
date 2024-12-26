//
//  ChatViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation
import CoreLocation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var chat: Chat?
    @Published var chats: [Chat]?
    @Published var localizedChats: [Chat] = []
    @Published var isLoading: Bool = false
    
    private let chatRepository: ChatRepository = ChatRepository()
    
    func getChats() {
        isLoading = true

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            DispatchQueue.main.async {
                self?.localizedChats = []
                self?.isLoading = false
            }
        }
    }


    
    func createChat(chatName: String, zoneSize: ZoneSize, location: Coordinate, maxConnections: Int) async -> Bool {
        let createdChat = await chatRepository.createChat(chatName: chatName, zoneSize: zoneSize, location: location, maxConnections: maxConnections)
        
        if let createdChat = createdChat {
            await MainActor.run {
                self.chat = createdChat
            }
            return true
        } else {
            return false
        }
    }
}
