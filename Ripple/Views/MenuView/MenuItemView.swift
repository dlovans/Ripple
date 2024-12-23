//
//  MenuItemView.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-22.
//

import SwiftUI

struct MenuItemView: View {
    let menuItem: Int
    let menuItemText: String
    let menuItemImage: String
    @Binding var selection: Int
    
    var body: some View {
        Button {
            selection = menuItem
        } label: {
            VStack (spacing: 0) {
                Text(menuItemText)
                    .foregroundStyle(selection == menuItem ? .emerald : .textcolor)
                Image(menuItemImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(selection == menuItem ? .emerald : .textcolor)
                    .frame(width: 20, height: 20)
            }
        }
        .frame(width: 80)
    }
}
