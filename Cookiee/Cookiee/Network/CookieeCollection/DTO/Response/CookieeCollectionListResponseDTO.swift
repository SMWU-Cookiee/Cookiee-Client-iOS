//
//  CookieeCollectionResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import Foundation

struct CookieeCollectionListResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: [CookieeCollectionResultData]
}

struct CookieeCollectionResultData: Codable {
    let categoryId: Int64
    let categoryName: String
    let categoryColor: String
    let collectionExist: Bool
}
