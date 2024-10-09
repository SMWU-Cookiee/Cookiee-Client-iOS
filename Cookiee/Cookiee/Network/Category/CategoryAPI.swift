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
    case postCategory(userId: String, requestBody: CategoryRequestDTO)
    case putCategory(userId: String, cateId: String, requestBody: CategoryRequestDTO)
    case deleteCategory(userId: String, cateId: String)
}

extension CategoryAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getCategoryList:
            return .accessTokenHeaderForJson
        case .postCategory:
            return .accessTokenHeaderForJson
        case .putCategory:
            return .accessTokenHeaderForJson
        case .deleteCategory:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getCategoryList(userId: let userId):
            return "/api/v2/categories/\(userId)"
        case .postCategory(userId: let userId, requestBody: _):
            return "/api/v2/categories/\(userId)"
        case .putCategory(userId: let userId, cateId: let cateId, requestBody: _):
            return "/api/v2/categories/\(userId)/\(cateId)"
        case .deleteCategory(userId: let userId, cateId: let cateId):
            return "/api/v2/categories/\(userId)/\(cateId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoryList:
            return .get
        case .postCategory:
            return .post
        case .putCategory:
            return .put
        case .deleteCategory:
            return .delete
        }

    }
    
    var task: Moya.Task {
        switch self {
        case .getCategoryList(_):
            return .requestPlain
        case .postCategory(_,  let requestBody):
            return .requestJSONEncodable(requestBody)
        case .putCategory(_, _, let requestBody):
            return .requestJSONEncodable(requestBody)
        case .deleteCategory(userId: _, cateId: _):
            return .requestPlain
        }
    }
}
