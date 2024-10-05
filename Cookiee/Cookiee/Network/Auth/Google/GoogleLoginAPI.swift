//
//  GoogleLoginAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/1/24.
//

import Foundation
import Moya

enum GoogleLoginAPI {
    case getGoogleLogin(socialId: String)
}

extension GoogleLoginAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForJson
    }
    
    var path: String {
        switch self {
        case .getGoogleLogin(let socialId):
            return "/api/google/\(socialId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGoogleLogin:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getGoogleLogin(_):
            return .requestPlain
        }
    }
}
