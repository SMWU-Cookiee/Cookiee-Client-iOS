//
//  LogOutAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/24/24.
//

import Foundation
import Moya

enum LogOutAPI {
    case putLogOut
}

extension LogOutAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForJson
    }
    
    var path: String {
        switch self {
        case .putLogOut:
            return "/api/auth/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putLogOut:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .putLogOut:
            return .requestPlain
        }
    }
}

