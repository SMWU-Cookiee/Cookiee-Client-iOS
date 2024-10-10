//
//  AppleLoginRequestDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/20/24.
//

import Foundation

struct AppleLoginRequestDTO: Codable {
    let IdentityToken: String
    let AuthorizationCode: String
}
