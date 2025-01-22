//
//  CategorySelectorView.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import SwiftUI

struct CategorySelectorView: View {
    @ObservedObject var categorySelectViewModel: CategorySelectViewModel
    
    @Binding var isCategorySelectButtonTapped: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("카테고리")
                .font(.Body1_M)
                .foregroundStyle(Color.Gray05)
                .frame(width: 75, alignment: .leading)
            Button(action: {
                isCategorySelectButtonTapped = true
            }) {
                HStack {
                    if (categorySelectViewModel.selectedCategory.isEmpty) {
                        Text("카테고리를 선택해주세요.")
                            .font(.Body0_M)
                            .foregroundStyle(Color.Black)
                    } else {
                        ForEach(categorySelectViewModel.selectedCategory, id: \.categoryId) { category in
                            CategoryLabelViewDeletable(
                                name: category.categoryName,
                                color: category.categoryColor,
                                action: {
                                    categorySelectViewModel.removeCategoryFromEvent(id: category.categoryId)
                                }
                            )
                            .padding(.horizontal, 1)
                        }
                    }
                    Spacer()
                    Image("UnderDropBlack")
                        .padding(2)
                }
                .padding(10)
                .frame(height: 40)
                .background(Color.Gray01)
                .cornerRadius(5)
            }
        }
        .padding(.bottom, 25)
    }
}
