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
    
    private let chatRepository: ChatRepository = ChatRepository()
    
    func createChat(chatName: String, zoneSize: ZoneSize, location: CLLocationCoordinate2D, maxConnections: Int) async -> Bool {
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
