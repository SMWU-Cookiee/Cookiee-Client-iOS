//
//  TokenRefreshAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Moya

enum TokenRefreshAPI {
    case postRefreshToken
}

extension TokenRefreshAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .postRefreshToken:
            return .refreshTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .postRefreshToken:
            return "api/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postRefreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postRefreshToken:
            return .requestPlain
        }
    }
}
