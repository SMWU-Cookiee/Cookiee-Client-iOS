//
//  UserProfileResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation

struct ProfileResponseDTO : Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: ProfileResultData
}

struct ProfileResultData : Codable {
    let userId: Int
    let nickname: String
    let email: String
    let profileImage: String?
    let selfDescription: String
    let categories: [CategoryResultData]
}
