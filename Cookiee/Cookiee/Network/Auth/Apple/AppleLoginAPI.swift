//
//  AppleLoginAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/20/24.
//

import Foundation
import Moya

enum AppleLoginAPI {
    case postAppleLogin(request: AppleLoginRequestDTO)
}

extension AppleLoginAPI: BaseTargetType {
    var headerType: HeaderType {
        .noneHeader
    }
    
    var headers: [String: String]? {
        switch self {
        case .postAppleLogin(let request):
            return [
                "IdentityToken": request.IdentityToken,
                "AuthorizationCode": request.AuthorizationCode,
                "Content-Type": "application/json"
            ]
        }
    }

    
    var path: String {
        switch self {
        case .postAppleLogin:
            return "/api/auth/login/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postAppleLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postAppleLogin(let request):
            return .requestJSONEncodable(request)
        }
    }
}
