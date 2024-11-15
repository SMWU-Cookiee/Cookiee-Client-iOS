//
//  CategoryListViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation

//struct CategoryForListRowDTO : Identifiable {
//    let categoryId: Int64
//    let categoryName: String
//    let categoryColor: String
//    
//    var id: Int64 {
//        return categoryId
//    }
//}

class CategoryListViewModel: ObservableObject {
    @Published var categories: [CategoryResultData] = []
    @Published var isUpdateSuccess: Bool = false

    let categoryService = CategoryService()

    func loadCategoryListData() {
        categoryService.getCategoryList { result in
            switch result {
            case .success(let categoryList):
                DispatchQueue.main.async {
                    self.categories = categoryList.result.map {
                        CategoryResultData(
                            categoryId: $0.categoryId,
                            categoryName: $0.categoryName,
                            categoryColor: $0.categoryColor
                        )
                    }
                    print("✅ loadCategoryListData 성공")
                    print("🍎 loadCategoryListData 결과 : ", self.categories)
                }
            case .failure(let error):
                print("❌ Error loading categories: \(error)")
            }
        }
    }


    
    func addCategory(categoryName: String, categoryColor: String) {
        let categoryRequest = CategoryRequestDTO(categoryName: categoryName, categoryColor: categoryColor)
        
        categoryService.postCategory(requestBody: categoryRequest) { result in
            switch result {
            case .success(let categoryResponse):
                DispatchQueue.main.async {
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
                case .success:
                    DispatchQueue.main.async {
                        self.isUpdateSuccess = true
                        self.loadCategoryListData()
                    }
                case .failure(let error):
                    print("updateCategory error:", error)
                }
            }
        }
    
    func removeCategory(categoryId: String) {
        categoryService.deleteCategory(cateId: categoryId.description) { result in
            switch result {
            case .success(let categoryResponse):
                DispatchQueue.main.async {
                    self.loadCategoryListData()
                    print("✅ removeCategory 성공")
                    print("🍎 removeCategory 결과 : ", categoryResponse)
               }

            case .failure(let error):
                print("removeCategory error:", error)
            }
        }
    }
}
