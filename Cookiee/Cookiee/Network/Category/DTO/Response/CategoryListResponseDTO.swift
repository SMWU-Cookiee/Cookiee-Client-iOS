//
//  CategoryListResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation

struct CategoryListResponseDTO : Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: [CategoryResultData]
}

struct CategoryResultData: Codable {
    let categoryId: Int64
    let categoryName: String
    let categoryColor: String
}
