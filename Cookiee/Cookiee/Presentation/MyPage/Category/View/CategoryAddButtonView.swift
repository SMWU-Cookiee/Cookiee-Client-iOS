//
//  CategoryAddButtonView.swift
//  Cookiee
//
//  Created by minseo Kyung on 11/16/24.
//

import SwiftUI

struct CategoryAddButtonView: View {
    @State var name: String = ""
    @State var toggleIsTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.Gray02)
                    .frame(width: 25, height: 25)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    .overlay(Image("Plus"))
                HStack {
                    Button(action: {
                        toggleIsTapped()
                    }, label: {
                        Text("추가하기")
                            .font(.Body1_M)
                            .foregroundColor(.black)
                    })
                }
                .font(.Body1_M)
                .frame(height: 35)
                Spacer()
            }
        }
    }
}
