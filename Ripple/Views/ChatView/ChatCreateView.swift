//
//  ChatCreateView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-24.
//

import SwiftUI

struct ChatCreateView: View {
    @State private var createChatTitle: String = ""
    @State private var zoneSize: Int = 1
    @State private var maxUsers: Int = 1
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            Color.stone
                .ignoresSafeArea(.all)
            VStack (alignment: .leading) {
                Text("Create Chat")
                    .font(.title)
                    .foregroundStyle(.textcolor)
                    .padding(.bottom, 20)
                VStack (spacing: 10) {
                    TextField("Title of your chat...", text: $createChatTitle)
                        .padding()
                        .foregroundStyle(.textcolor)
                        .overlay(alignment: .leading) {
                            if createChatTitle.isEmpty {
                                Text("Title of your chat...")
                                    .foregroundStyle(.textcolor)
                                    .opacity(0.5)
                                    .padding(.leading, 20)
                                    .allowsHitTesting(false)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.emerald, lineWidth: 2)
                        }
                    
                    HStack {
                        Text("Zone size " )
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
                        Text("Max number of users " )
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
                    
                    HStack {
                        Button {
                            // Create Chat
                        } label: {
                            Text("Create")
                                .foregroundStyle(.textcolor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(createChatTitle.isEmpty ? Color.gray : .emerald)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(createChatTitle.isEmpty)
                        
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.textcolor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }
    }
}
