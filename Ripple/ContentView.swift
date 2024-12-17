//
//  ContentView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-11-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.stone)
                .ignoresSafeArea()

            VStack {
                AuthView(authType: .login)
            }
            .padding(1)
        }
    }
}

#Preview {
    ContentView()
}
