//
//  TokenRefreshResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation

struct TokenRefreshResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: TokenRefreshResultData
}

struct TokenRefreshResultData: Codable {
    let accessToken: String
}
