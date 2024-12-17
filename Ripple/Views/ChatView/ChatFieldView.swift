//
//  ChatBarView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-27.
//

import SwiftUI

struct ChatFieldView: View {
    @State var chatText: String = ""
    @FocusState var displayKeyboard: Bool
    
    var body: some View {
        HStack {
            TextField("Type something...", text: $chatText)
                .foregroundStyle(.white)
                .overlay(alignment: .leading) {
                    if chatText.isEmpty {
                        Text("Type something...")
                            .foregroundStyle(.white)
                            .padding(.leading, 4)
                            .allowsHitTesting(false)
                    }
                }
                .keyboardType(.default)
            if !chatText.isEmpty {
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(.white)
                }
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
