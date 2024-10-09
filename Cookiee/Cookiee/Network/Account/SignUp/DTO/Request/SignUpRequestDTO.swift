//
//  SignUpRequestDTO.swift.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let email : String
    let name : String
    let nickname : String
    let selfDescription : String
    let socialId : String
    let socialLoginType : String
    let image: Data?
}
