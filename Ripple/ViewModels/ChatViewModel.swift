//
//  ChatViewModel.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-20.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var chat: Chat?
    @Published var chats: [Chat]?
    @Published var localizedChats: [Chat] = []
    @Published var isLoading: Bool = false
    
    private let chatRepository: ChatRepository = ChatRepository()
    private var chatListener: ListenerRegistration?
    
    func startFetchingChats(center: Coordinate?) {
        guard let center else {
            print("No location provided.")
            return
        }
            stopFetchingChats()

        chatListener = chatRepository.fetchChats(center: center) { [weak self] chats in
                Task { @MainActor in
                    self?.localizedChats = chats
                }
            }
        }

        func stopFetchingChats() {
            chatListener?.remove()
            chatListener = nil
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
