//
//  ChatBarView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-27.
//

import SwiftUI

struct ChatFieldView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var messageViewModel: MessageViewModel
    
    @State var chatText: String = ""
    @FocusState var displayKeyboard: Bool
    
    var body: some View {
        HStack {
            TextField("Type something...", text: $chatText, axis: .vertical)
                .foregroundStyle(.textcolor)
                .overlay(alignment: .leading) {
                    if chatText.isEmpty {
                        Text("@\(userViewModel.user?.username ?? "")")
                            .foregroundStyle(.textcolor)
                            .opacity(0.5)
                            .padding(.leading, 4)
                            .allowsHitTesting(false)
                    }
                }
                .lineLimit(0...10)
                .keyboardType(.default)
                .onChange (of: chatText) {
                    if chatText.count > 200 {
                        chatText = String(chatText.prefix(200))
                    }
                }
            if !chatText.isEmpty {
                Button {
                    Task {
                        if !chatText.isEmpty || chatViewModel.chat != nil {
                            await messageViewModel.addMessage(message: chatText, username: userViewModel.user!.username, userId: userViewModel.user!.id, isPremium: userViewModel.user!.isPremium, chatId: chatViewModel.chat!.id)
                            chatText = ""
                        }
                    }
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(.textcolor)
                }
                .disabled(chatText.isEmpty || chatViewModel.chat == nil)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.stone)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.emerald, lineWidth: 2)
        }
    }
}

#Preview {
    ChatFieldView()
}
