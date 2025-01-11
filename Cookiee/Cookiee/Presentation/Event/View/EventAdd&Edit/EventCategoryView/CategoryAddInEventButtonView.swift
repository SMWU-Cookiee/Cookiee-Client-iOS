//
//  CategoryAddInEventButtonView.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import SwiftUI

struct CategoryAddInEventButtonView: View {
    @Binding var isCategorySelectButtonTapped: Bool
    @ObservedObject var categorySelectViewModel: CategorySelectViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                isCategorySelectButtonTapped = false
            }, label: {
                Text("카테고리 추가하기")
                    .font(.Body0_SB)
                    .foregroundStyle(Color.Gray00)
            })
            .frame(width: 363, height: 44)
            .background(categorySelectViewModel.selectedCategory.isEmpty ? Color.Gray03 : Color.Brown00)
            .cornerRadius(10)
        }
        .padding(10)
        .frame(height: 67)
        .background(Color.White)
        .shadow(color: .black.opacity(0.05), radius: 13, x: 0, y: -10)
    }
}
