//
//  CategoryListResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation

struct CategoryListResponseDTO : Codable {
    let isSuccess: Bool
    let statusCode: Int32
    let message: String
    let result: [CategoryResultData]
}

struct CategoryPostResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int32
    let message: String
    let result: CategoryResultData
}

struct CategoryResultData: Codable, Identifiable {
    let categoryId: Int64
    let categoryName: String
    let categoryColor: String
    
    var id: Int64 {
        return categoryId
    }
}
