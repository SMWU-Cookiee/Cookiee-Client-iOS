//
//  SignOutApi.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/9/24.
//

import Foundation
import Moya

enum SignOutAPI {
    case deleteSignOut
}

extension SignOutAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForJson
    }
    
    var path: String {
        switch self {
        case .deleteSignOut:
            return "/api/auth/signout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteSignOut:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .deleteSignOut:
            return .requestPlain
        }
    }
}
