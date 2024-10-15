//
//  ProfileAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation
import Moya

enum ProfileAPI {
    case getUserProfile(userId: String)
}

extension ProfileAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getUserProfile:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getUserProfile(userId: let userId):
            return "/api/users/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserProfile:
            return .requestPlain
        }
    }
}
