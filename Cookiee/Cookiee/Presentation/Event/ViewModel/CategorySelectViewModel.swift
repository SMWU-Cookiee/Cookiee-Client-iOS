//
//  CategorySelectViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/20/24.
//

import Foundation

class CategorySelectViewModel: ObservableObject {
    
    @Published var selectedCategory: [CategoryResultData] = []

    
    func addCategoryToEvent(id: Int64, name: String, color: String) {
        let category = CategoryResultData(categoryId: id, categoryName: name, categoryColor: color)
        selectedCategory.append(category)
    }
    
    func removeCategoryFromEvent(id: Int64) {
        selectedCategory.removeAll(where: { $0.categoryId == id })
    }
    
    func isCategorySelected(id: Int64) -> Bool {
        return selectedCategory.contains(where: { $0.categoryId == id })
    }
}

