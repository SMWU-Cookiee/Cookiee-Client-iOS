//
//  CategoryListViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation

class CategoryListViewModel: ObservableObject {
    @Published var categories: [CategoryResultData] = []
    {
//        willSet(new) {
//            print("🔥 이 카테고리 값으로 변경될 예정 \(new)")
//        }
        didSet {
            print("🔥 didSet 작동함")
            loadCategoryListData()
          }
    }
    let categoryService = CategoryService()

    func loadCategoryListData() {
        categoryService.getCategoryList() { result in
            switch result {
            case .success(let categoryList):
                DispatchQueue.main.async {
                    self.categories = categoryList.result
                    print("✅ loadCategoryListData 성공")
                    print("🍎 loadCategoryListData 결과 : ", self.categories)

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addCategory(categoryName: String, categoryColor: String) {
        let categoryRequest = CategoryRequestDTO(categoryName: categoryName, categoryColor: categoryColor)
        
        categoryService.postCategory(requestBody: categoryRequest) { result in
            switch result {
            case .success(let categoryResponse):
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                   self.loadCategoryListData()
                    print("✅ addCategory 성공")
                    print("🍎 addCategory 결과 : ", categoryResponse)
               }
        
            case .failure(let error):
                print("addCategory error:", error)
            }
        }
    }
    
    func updateCategory(categoryId: String, categoryName: String, categoryColor: String) {
        let categoryRequest = CategoryRequestDTO(categoryName: categoryName, categoryColor: categoryColor)
        
        categoryService.putCategory(cateId: categoryId.description, requestBody: categoryRequest) { result in
            switch result {
            case .success(let categoryResponse):
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                   self.loadCategoryListData()
                    print("✅ updateCategory 성공")
                    print("🍎 updateCategory 결과 : ", categoryResponse)
               }

            case .failure(let error):
                print("updateCategory error:", error)
            }
        }
    }
}
