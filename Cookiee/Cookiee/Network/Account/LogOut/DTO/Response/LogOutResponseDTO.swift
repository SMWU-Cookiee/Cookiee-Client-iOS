//
//  LogOutResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/24/24.
//

import Foundation

struct LogOutResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: String?
}
