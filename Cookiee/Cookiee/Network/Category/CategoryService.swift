//
//  CategoryService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/5/24.
//

import Foundation
import Moya

class CategoryService {
    let provider = MoyaProvider<CategoryAPI>(session: Session(interceptor: TokenInterceptor.shared))

    func getCategoryList(userId: String, completion: @escaping (Result<CategoryListResponseDTO, Error>) -> Void) {
        provider.request(.getCategoryList(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let categoryResponse = try JSONDecoder().decode(CategoryListResponseDTO.self, from: response.data)
                    completion(.success(categoryResponse))
                } catch {
                    completion(.failure(error))
                    print("getCategoryList Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("getCategoryList error:", error)
            }
        }
    }
}
