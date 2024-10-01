//
//  GoogleLoginResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/1/24.
//

import Foundation

struct GoogleLoginResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: GoogleLoginResultData
}

struct GoogleLoginResultData: Codable {
    let socialId: String
    let userId: Int64?
    let name: String?
    let email: String?
    let socialType: String
    let accessToken: String?
    let refreshToken: String?
    let isNewMember: Bool
}
