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
    @Published var chats: [Chat] = []
    @Published var chatIsLoading: Bool = true
    
    private var presenceId: String? = nil
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
            if let presenceId = self.presenceId {
                await self.chatRepository.updatePresence(chatId: chatId, presenceId: presenceId)
            } else {
                self.presenceId = await self.chatRepository.createPresence(chatId: chatId)
                if let newPresenceId = self.presenceId {
                    await self.chatRepository.updatePresence(chatId: chatId, presenceId: newPresenceId)
                }
            }
            

        }
        queryTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [weak self] _ in
            Task {
                await self?.chatRepository.updatePresence(chatId: chatId, presenceId: self?.presenceId ?? "")
            }
        }
    }
    
    func stopListeningToChat() {
        self.queryTimer?.invalidate()
        self.queryTimer = nil
        Task {
            await chatRepository.deletePresence(chatId: self.chat?.id ?? nil, presenceId: self.presenceId)
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
                self?.chats = chats
            }
        }
        print("Fetched chats and attached listener.")
    }
    
    func stopFetchingChats() {
        self.chatsListener?.remove()
        self.chatsListener = nil
    }
    
    
    func createChat(chatName: String, zoneSize: ZoneSize, location: Coordinate, maxConnections: Int, description: String, createdByUserId: String) async -> String? {
        let createdChatId = await chatRepository.createChat(chatName: chatName, zoneSize: zoneSize, location: location, maxConnections: maxConnections, description: description, createdByUserId: createdByUserId)
        
        if let createdChatId {
            return createdChatId
        } else {
            return nil
        }
    }
}
