//
//  CookieeCollectionAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import Foundation
import Moya

enum CookieeCollectionAPI {
    case getCookieeCollectionList(userId: String)
}

extension CookieeCollectionAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getCookieeCollectionList:
            return .accessTokenHeaderForJson
        }
    }
        
    var path: String {
        switch self {
        case .getCookieeCollectionList(userId: let userId):
            return "/api/v2/categories/collection/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCookieeCollectionList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCookieeCollectionList:
            return .requestPlain
        }
    }
}

