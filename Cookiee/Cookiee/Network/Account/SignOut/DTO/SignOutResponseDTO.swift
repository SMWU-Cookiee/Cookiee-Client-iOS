//
//  SignOutResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/9/24.
//

import Foundation

struct SignOutResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: String?
}
