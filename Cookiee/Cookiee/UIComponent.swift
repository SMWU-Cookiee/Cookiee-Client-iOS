//
//  UIComponent.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/16/24.
//

import SwiftUI


struct CategoryLabel: View {
    @State var name: String
    @State var color: Color
    
    var body: some View {
        Label {
            Text("#" + name)
                .font(.Body1_M)
                .foregroundColor(.black)
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(color)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                )
        } icon: {
            EmptyView()
        }
    }
}
