//
//  AppleLoginResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/11/24.
//

import Foundation

struct AppleLoginResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: AppleLoginResultData
}

struct AppleLoginResultData: Codable {
    let socialId: String
    let userId: Int64?
    let name: String?
    let email: String?
    let socialType: String
    let accessToken: String?
    let refreshToken: String?
    let isNewMember: Bool
}
