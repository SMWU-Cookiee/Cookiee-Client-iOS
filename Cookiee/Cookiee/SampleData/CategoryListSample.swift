//
//  CategoryListSample.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/22/24.
//

import SwiftUI

//struct Category: Codable {
//    let id: Int
//    let name: String
//    let color: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "categoryId"
//        case name = "categoryName"
//        case color = "categoryColor"
//    }
//}

struct CategoryListData: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: [Category]
}

class CategoryListViewModel: ObservableObject {
    @Published var categoryListData: CategoryListData?
    
    init() {
        self.loadCategoryListData()
    }
    
    func loadCategoryListData() {
        let jsonData = """
        {
            "isSuccess": true,
            "statusCode": 1000,
            "message": "카테고리 조회 요청에 성공하였습니다.",
            "result": [
                {
                    "categoryId": 9,
                    "categoryName": "동기들",
                    "categoryColor": "#D2E7FF"
                },
                {
                    "categoryId": 10,
                    "categoryName": "여행",
                    "categoryColor": "#FFD2D2"
                },
                {
                    "categoryId": 11,
                    "categoryName": "맛집",
                    "categoryColor": "#D0FFBA"
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let decodedData = try JSONDecoder().decode(CategoryListData.self, from: jsonData)
            self.categoryListData = decodedData
        } catch {
            print("이벤트 상세 정보 조회 Decode 실패: \(error)")
        }
    }
}


