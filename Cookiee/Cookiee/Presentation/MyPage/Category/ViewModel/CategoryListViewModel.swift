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
        guard let userId = loadFromKeychain(key: "userId") else {
            print("loadCategoryListData: userId를 찾을 수 없음")
            return
        }

        let categoryService = CategoryService()
        categoryService.getCategoryList(userId: userId) { result in
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
}
