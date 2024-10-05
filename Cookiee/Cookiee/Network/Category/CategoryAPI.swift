//
//  CategoryAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation
import Moya

enum CategoryAPI {
    case getCategoryList(userId: String)
}

extension CategoryAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForGet
    }
    
    var path: String {
        switch self {
        case .getCategoryList(userId: let userId):
            return "/api/v2/categories/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoryList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCategoryList(_):
            return .requestPlain
        }
    }
}
