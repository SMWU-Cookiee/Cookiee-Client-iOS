//
//  CustomTextFieldWithLabel.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import SwiftUI

struct CustomTextFieldWithLabel: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.Body1_M)
                .foregroundStyle(Color.Gray05)
                .frame(width: 75, alignment: .leading)
            
            CustomTextField(target: $text, placeholder: placeholder)
                .focused($isFocused)
        }
        .padding(.bottom, 25)
    }
}
