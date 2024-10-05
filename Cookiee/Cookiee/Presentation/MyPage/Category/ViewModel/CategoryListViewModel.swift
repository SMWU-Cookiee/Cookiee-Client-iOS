//
//  CategoryListViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation

class CategoryListViewModel: ObservableObject {
    @Published var categories: [CategoryResultData] = []

    func loadCategoryListData() {
        let categoryService = CategoryService()
        categoryService.getCategoryList() { result in
            switch result {
            case .success(let categoryList):
                DispatchQueue.main.async {
                    self.categories = categoryList.result
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addCategory(categoryName: String, categoryColor: String) {
        let categoryService = CategoryService()
        let categoryRequest = CategoryRequestDTO(categoryName: categoryName, categoryColor: categoryColor)
        
        categoryService.postCategory(requestBody: categoryRequest) { result in
            switch result {
            case .success(let categoryResponse):
                print("categoryResponse - ", categoryResponse)
                DispatchQueue.main.async {
                    self.loadCategoryListData()
                }
            case .failure(let error):
                print("addCategory error:", error)
            }
        }
    }
}
