//
//  ChatView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-22.
//

import SwiftUI

struct ChatView: View {
    @State private var enteredText = ""
//    @Binding var messages: [Message]
    var dummyMessages = ["Hello world", "Goodbye m8"]
    
    var body: some View {
            LazyVStack {
                HStack {
                    ZStack {
                        Circle()
                            .fill(.gray)
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 40))

                    }
                    .frame(width: 50, height: 50)
                }
                Divider()
                    .overlay(.red)
                    .frame(width: 400)
            }
    }
}

#Preview {
    ChatView()
}
