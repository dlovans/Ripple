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
    
    @State var disableButton: Bool = false
    @State var chatText: String = ""
    @FocusState var displayKeyboard: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $chatText, axis: .vertical)
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
                    let tempChatText = self.chatText
                    self.chatText = ""
                    Task {
                        disableButton = true
                        if !chatText.isEmpty || chatViewModel.chat != nil {
                            await messageViewModel.addMessage(message: tempChatText, username: userViewModel.user!.username, userId: userViewModel.user!.id, isPremium: userViewModel.user!.isPremium, chatId: chatViewModel.chat!.id)
                            disableButton = false
                        }
                    }
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(.emerald)
                }
                .disabled(chatText.isEmpty || chatViewModel.chat == nil || disableButton)
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

//#Preview {
//    ChatFieldView()
//}
