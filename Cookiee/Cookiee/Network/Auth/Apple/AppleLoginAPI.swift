//
//  AppleLoginAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/11/24.
//

import Foundation
import Moya

enum AppleLoginAPI {
    case postApplelogin(identityToken: String, authorizationCode: String)
}

extension AppleLoginAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .postApplelogin(let identityToken, let authorizationCode):
            return .appleLoginHeader(identityToken: identityToken, authorizationCode: authorizationCode)
        }
    }
    
    var path: String {
        switch self {
        case .postApplelogin(_, _):
            return "/api/auth/login/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postApplelogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postApplelogin(_, _):
            return .requestPlain
        }
    }
}
