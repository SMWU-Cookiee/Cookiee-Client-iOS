//
//  CustomTextField.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var target: String
    var placeholder: String
    
    var body: some View {
        TextField("\(target)", text: $target)
            .placeholder(when: target.isEmpty) {
                Text("\(placeholder)")
                    .foregroundStyle(Color.Brown05)
                    .font(.Body0_M)
        }
        .padding(10)
        .font(.Body0_M)
        .frame(height: 40)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.Brown02, lineWidth: 1)
        )
    }
}
