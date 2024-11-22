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
            Color(red: 54/255, green: 69/255, blue: 79/255)
                .ignoresSafeArea()
            VStack {
                Text("Ripple")
            }
            VStack {
                Spacer()
                MenuView()

            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
