//
//  CategorySelectView.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import SwiftUI

struct CategorySelectView: View {
    @ObservedObject var categoryListViewModel: CategoryListViewModel
    @ObservedObject var categorySelectViewModel: CategorySelectViewModel
    
    var body: some View {
        VStack(spacing: 18) {
            Text("내 카테고리")
                .font(.Head1_B)
                .padding(.top, 25)
            
            ScrollView {
                ForEach(categoryListViewModel.categories, id: \.id) { category in
                    CategorySelectButtonView(
                        id: category.categoryId,
                        name: category.categoryName,
                        color: category.categoryColor,
                        viewModel: categorySelectViewModel
                    )
                }
            }
        }
    }
}
