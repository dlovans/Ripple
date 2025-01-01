//
//  ChatCreateView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-24.
//

import SwiftUI

struct ChatCreateView: View {
    @EnvironmentObject var messageViewModel: MessageViewModel
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var chatViewModel: ChatViewModel
    @Binding var navigateToChat: Bool
    
    @State private var createChatTitle: String = ""
    @State private var zoneSize: Int = 1
    @State private var maxUsers: Int = 1
    @State private var disableButtons: Bool = false
    @State private var description: String = ""
    
    private var disableCreateButton: Bool {
        return createChatTitle.isEmpty || disableButtons || description.isEmpty
    }
    
    private var zoneSizeConstant: ZoneSize {
        switch self.zoneSize {
        case 0: return .small
        case 1: return .medium
        case 2: return .large
        case 3: return .extraLarge
        default: return .medium
        }
    }
    
    private var maxConnections: Int {
        switch maxUsers {
        case 0: return 50
        case 1: return 100
        case 2: return 250
        case 3: return 500
        case 4: return 750
        case 5: return 1000
        default: return 100
        }
    }
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Create Chat")
                    .font(.title)
                    .foregroundStyle(.textcolor)
                    .padding(.bottom, 20)
                VStack(spacing: 10) {
                    TextField("Title of your chat...", text: $createChatTitle)
                        .padding()
                        .foregroundStyle(.textcolor)
                        .overlay(alignment: .leading) {
                            if createChatTitle.isEmpty {
                                Text("Title of your chat...")
                                    .foregroundStyle(.textcolor)
                                    .opacity(0.5)
                                    .padding(.leading, 18)
                                    .allowsHitTesting(false)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.emerald, lineWidth: 2)
                        }
                    
                    HStack {
                        Text("Zone size")
                            .foregroundStyle(.textcolor)
                        Spacer()
                        Picker("", selection: $zoneSize) {
                            Text("Small").tag(0)
                            Text("Medium").tag(1)
                            Text("Large").tag(2)
                            Text("Extra Large").tag(3)
                        }
                        .tint(.textcolor)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.emerald, lineWidth: 2)
                    }
                    
                    HStack {
                        Text("Max number of users")
                            .foregroundStyle(.textcolor)
                        Spacer()
                        Picker("", selection: $maxUsers) {
                            Text("50").tag(0)
                            Text("100").tag(1)
                            Text("250").tag(2)
                            Text("500").tag(3)
                            Text("750").tag(4)
                            Text("1000").tag(5)
                        }
                        .tint(.textcolor)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.emerald, lineWidth: 2)
                    }
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(7, reservesSpace: true)
                        .padding()
                        .foregroundStyle(.textcolor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Describe purpose of chat...")
                                    .foregroundStyle(.textcolor)
                                    .opacity(0.5)
                                    .padding(.leading, 18)
                                    .padding(.top, 18)
                                    .allowsHitTesting(false)
                            }
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.emerald, lineWidth: 2)
                        }
                        .onChange(of: description) { _, newDescription in
                            if description.count > 200 {
                                description = String(description.prefix(200))
                            }
                        }
                    
                    HStack {
                        Button {
                            disableButtons = true
                            Task { @MainActor in
                                disableButtons = true
                                
                                let newChat = await chatViewModel.createChat(
                                    chatName: createChatTitle,
                                    zoneSize: zoneSizeConstant,
                                    location: locationService.lastKnownLocation!,
                                    maxConnections: maxConnections,
                                    description: description
                                )
                                
                                if let newChat {
                                    chatViewModel.startListeningToChat(for: newChat)
                                    messageViewModel.subscribeToMessages(chatId: newChat)
                                    navigateToChat = true
                                    isPresented.toggle()
                                } else {
                                    disableButtons = false
                                    return
                                }
                                
                            }
                        } label: {
                            Text("Create")
                                .foregroundStyle(.textcolor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(disableCreateButton ? Color.gray : .emerald)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(disableCreateButton)
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.textcolor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(disableButtons ? Color.gray : .red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(disableButtons)
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            
            if disableButtons {
                ZStack {
                    SpinnerView()
                    Text("Creating chat...Hang tight!")
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 50)
                        .font(.headline)
                        .foregroundStyle(.textcolor)
                }
            }
        }
    }
}
