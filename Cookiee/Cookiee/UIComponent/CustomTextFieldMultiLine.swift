//
//  CustomTextFieldMultiLine.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/4/24.
//

import SwiftUI

struct CustomTextFieldMultiLine: View {
    @Binding var target: String
    var placeholder: String
    
    var body: some View {
        TextField("\(target)", text: $target, axis: .vertical)
            .placeholder(when: target.isEmpty) {
                Text("\(placeholder)")
                    .foregroundStyle(Color.Gray04)
                    .font(.Body0_M)
            }
            .padding(10)
            .font(.Body0_M)
            .frame(minHeight: 40)
            .background(Color.Gray01)
            .cornerRadius(5)
            
    }
}
