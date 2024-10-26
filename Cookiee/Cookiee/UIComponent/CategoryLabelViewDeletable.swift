//
//  CategoryLabelView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/16/24.
//

import SwiftUI


struct CategoryLabelViewDeletable: View {
    @State var name: String
    @State var color: String
    
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("#" + name)
                .font(.Body1_M)
                .foregroundColor(.black)
                
            Image("XmarkSmall")
        })
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color(hex: color))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.Gray00, lineWidth: 1)
        )
    }
}
