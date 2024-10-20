//
//  EventInfoTextField.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/20/24.
//

import SwiftUI

struct EventInfoTextField : View {
    
    var fieldName: String
    var placeholder: String
    @State var field: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .font(.Body1_M)
                .foregroundStyle(Color.Gray05)
                .frame(width: 75, alignment: .leading)
            
            TextField("", text: $field)
                .placeholder(when: field.isEmpty) {
                    Text(placeholder)
                        .foregroundStyle(Color.Gray04)
                        .font(.Body0_M)
            }
            .padding(10)
            .frame(height: 40)
            .background(Color.Gray01)
            .cornerRadius(5)
        }
        .padding(.bottom, 25)
    }
}
