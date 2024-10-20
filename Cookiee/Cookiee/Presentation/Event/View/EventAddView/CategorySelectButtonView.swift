//
//  CategorySelectButtonView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/20/24.
//

import SwiftUI

struct CategorySelectButtonView : View {
    var id : Int64
    var name: String
    var color: String
    var viewModel: CategorySelectViewModel
    @State var isSelected: Bool = false
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            
            if isSelected {
                viewModel.countOfSelectedCategory += 1
            } else  {
                viewModel.countOfSelectedCategory -= 1
            }
        }, label: {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color(hex: color))
                    .frame(width: 25, height: 25)
                    .cornerRadius(5.0)
                    .padding(.leading, 15)
                
                Text(name)
                    .font(isSelected ? Font.Body1_SB : Font.Body1_R)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                if isSelected {
                    Image("CheckIcon")
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 7)
                }
            }
            .frame(width: 355, height: 47)
            .background(Color.Gray00)
            .cornerRadius(8.0)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? .black : Color.white.opacity(0), lineWidth: 1)
                    .frame(width: 348, height: 47)
            )
        })
        .frame(width: 348, height: 47)
        .background(Color.Gray00)
        .cornerRadius(8.0)

    }
}
