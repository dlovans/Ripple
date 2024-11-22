//
//  MenuView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-21.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack() {
                Button() {} label: {
                    VStack {
                        Image(systemName: "message.badge.filled.fill")
                            .tint(Color.emerald)
                            .font(.system(size: 30))
                        Text("Chat")
                            .tint(Color.emerald)
                            .font(.system(size: 15))
                    }
                }
                .frame(width: 70)
                Spacer()
                Button() {} label: {
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .tint(Color.emerald)
                            .font(.system(size: 30))
                        Text("Profile")
                            .tint(Color.emerald)
                            .font(.system(size: 15))
                    }
                }
                .frame(width: 70)
                Spacer()
                Button() {} label: {
                    VStack {
                        Image(systemName: "gear")
                            .tint(Color.emerald)
                            .font(.system(size: 30))
                        Text("Settings")
                            .tint(Color.emerald)
                            .font(.system(size: 15))
                    }
                }
                .frame(width: 70)
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
        }
        .frame(height: 60)
    }
}


#Preview {
    MenuView()
}
