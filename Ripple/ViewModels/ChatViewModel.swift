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
    @Published var isLoading: Bool = true
    @Published var chatIsLoading: Bool = true
    
    private let chatRepository: ChatRepository = ChatRepository()
    private var chatsListener: ListenerRegistration?
    private var chatListener: ListenerRegistration?
    
    func startListeningToChat(for chatId: String) {
        chatListener = chatRepository.fetchChat(chatId: chatId) { [weak self] chat in
            Task { @MainActor in
                self?.chat = chat
                self?.chatIsLoading = false
            }
        }
    }
    
    func stopListeningToChat() {
        chatListener?.remove()
        chatListener = nil
        chatIsLoading = true
    }
    
    func incrementConnection(for chatId: String) async {
        do {
            try await chatRepository.incrementConnection(chatId: chatId)
        } catch {
            print(error)
        }
    }
    
    func decrementConnection(for chatId: String) async {
        do {
            try await chatRepository.decrementConnection(chatId: chatId)
        } catch {
            print(error)
        }
    }
    
    func startFetchingChats(center: Coordinate?) {
        guard let center else {
            print("No location provided.")
            return
        }
        
        chatsListener = chatRepository.fetchChats(center: center) { [weak self] chats in
            Task { @MainActor in
                self?.localizedChats = chats
            }
        }
        isLoading = false
    }
    
    func stopFetchingChats() {
        chatsListener?.remove()
        chatsListener = nil
        isLoading = true
    }
    
    
    func createChat(chatName: String, zoneSize: ZoneSize, location: Coordinate, maxConnections: Int) async -> Bool {
        let createdChatId = await chatRepository.createChat(chatName: chatName, zoneSize: zoneSize, location: location, maxConnections: maxConnections)
        
        if let createdChatId {
            self.startListeningToChat(for: createdChatId)
            return true
        } else {
            return false
        }
    }
}
