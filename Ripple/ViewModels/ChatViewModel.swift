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
    private var queryTimer: Timer?

    
    func startListeningToChat(for chatId: String) {
        chatListener = chatRepository.fetchChat(chatId: chatId) { [weak self] chat in
            Task { @MainActor in
                self?.chat = chat
                self?.chatIsLoading = false
            }
        }
        Task {
            await self.chatRepository.updatePresence(chatId: chatId)
        }
        queryTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { _ in
            Task {
                await self.chatRepository.updatePresence(chatId: chatId)
            }
        }
    }
    
    func stopListeningToChat() {
        self.queryTimer?.invalidate()
        self.queryTimer = nil
        Task {
            await chatRepository.deletePresence(chatId: self.chat?.id ?? nil)
        }
        self.chatListener?.remove()
        self.chatListener = nil
        self.chatIsLoading = true
        self.chat = nil
    }
    
    func incrementConnection() async {
        guard let chatId = self.chat?.id else { return }

        do {
            try await chatRepository.incrementConnection(chatId: chatId)
        } catch {
            print(error)
        }
    }
    
    func decrementConnection() async {
        guard let chatId = self.chat?.id else { return }

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
        self.chatsListener?.remove()
        self.chatsListener = nil
        self.isLoading = true
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
