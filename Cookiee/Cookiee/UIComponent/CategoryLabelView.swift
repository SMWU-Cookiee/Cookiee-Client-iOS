//
//  CategoryLabelView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/16/24.
//

import SwiftUI


struct CategoryLabel: View {
    @State var name: String
    @State var color: String
    
    var body: some View {
        Label {
            Text("#" + name)
                .font(.Body1_M)
                .foregroundColor(.black)
                .padding(.horizontal, 5)
                .padding(.vertical, 4)
                .background(Color(hex: color))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.Gray00, lineWidth: 1)
                )
        } icon: {
            EmptyView()
        }
    }
}
