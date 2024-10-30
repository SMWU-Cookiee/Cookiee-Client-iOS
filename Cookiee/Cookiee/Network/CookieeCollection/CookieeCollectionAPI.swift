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
    case getCookieeCollectionDetail(userId: String, categoryId: Int64)
}

extension CookieeCollectionAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getCookieeCollectionList:
            return .accessTokenHeaderForJson
        case .getCookieeCollectionDetail:
            return .accessTokenHeaderForJson
        }
    }
        
    var path: String {
        switch self {
        case .getCookieeCollectionList(userId: let userId):
            return "/api/v2/categories/collection/\(userId)"
        case .getCookieeCollectionDetail(userId: let userId, categoryId: let categoryId):
            return "/api/v2/categories/collection/\(userId)/\(categoryId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCookieeCollectionList:
            return .get
        case .getCookieeCollectionDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCookieeCollectionList:
            return .requestPlain
        case .getCookieeCollectionDetail:
            return .requestPlain
        }
    }
}

