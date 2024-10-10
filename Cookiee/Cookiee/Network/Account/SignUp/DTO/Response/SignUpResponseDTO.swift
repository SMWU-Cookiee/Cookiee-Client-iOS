//
//  SignUpResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation

struct SignUpResponseDTO : Codable {
    let isSuccess: Bool
    let statusCode: Int32
    let message: String
    let result: SignUpResult
}

struct SignUpResult: Codable {
    let socialId: String
    let userId: Int
    let name: String
    let email: String
    let socialType: String
    let accessToken: String
    let refreshToken: String
    let isNewMember: Bool
}
