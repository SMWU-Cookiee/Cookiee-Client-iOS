//
//  CategorySelectBottomModal.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import SwiftUI

public struct CategorySelectBottomModal: View {
    @ObservedObject var categoryListViewModel: CategoryListViewModel
    @ObservedObject var categorySelectViewModel: CategorySelectViewModel
    @Binding var isCategorySelectButtonTapped: Bool
    
    public var body: some View {
        VStack {
            CategorySelectView(
                categoryListViewModel: categoryListViewModel,
                categorySelectViewModel: categorySelectViewModel
            )
            
            CategoryAddInEventButtonView(
                isCategorySelectButtonTapped: $isCategorySelectButtonTapped,
                categorySelectViewModel: categorySelectViewModel
            )
        }
        .onAppear {
            categoryListViewModel.loadCategoryListData()
        }
        .presentationDetents([.fraction(0.60)])
        .presentationDragIndicator(Visibility.visible)
    }
}
