//
//  EventDeleteDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/17/24.
//

import Foundation

struct EventDeleteDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: String?
}
