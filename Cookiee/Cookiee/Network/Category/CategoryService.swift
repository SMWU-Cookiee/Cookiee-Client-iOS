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
    
    private var userId: String

    init() {
        if let id = loadFromKeychain(key: "userId") {
            self.userId = id
        } else {
            self.userId = ""
            print("CategoryService init : userId를 찾을 수 없음")
        }
    }

    func getCategoryList(completion: @escaping (Result<CategoryListResponseDTO, Error>) -> Void) {
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
    
    func postCategory(requestBody: CategoryRequestDTO, completion: @escaping (Result<CategoryPostPutResponseDTO, Error>) -> Void) {
        provider.request(.postCategory(userId: userId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let categoryResponse = try JSONDecoder().decode(CategoryPostPutResponseDTO.self, from: response.data)
                    completion(.success(categoryResponse))
                } catch {
                    completion(.failure(error))
                    print("postCategory Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("postCategory error:", error.errorDescription as Any)
            }
        }
    }

    func putCategory(cateId: String, requestBody: CategoryRequestDTO, completion: @escaping (Result<CategoryPostPutResponseDTO, Error>) -> Void) {
        provider.request(.putCategory(userId: userId, cateId: cateId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let categoryResponse = try JSONDecoder().decode(CategoryPostPutResponseDTO.self, from: response.data)
                    completion(.success(categoryResponse))
                } catch {
                    completion(.failure(error))
                    print("putCategory Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("putCategory error:", error.errorDescription as Any)
            }
        }
    }
    
    func deleteCategory(cateId: String, completion: @escaping (Result<CategoryDeleteResponseDTO, Error>) -> Void) {
        provider.request(.deleteCategory(userId: userId, cateId: cateId)) { result in
            switch result {
            case .success(let response):
                do {
                    let categoryResponse = try JSONDecoder().decode(CategoryDeleteResponseDTO.self, from: response.data)
                    completion(.success(categoryResponse))
                } catch {
                    completion(.failure(error))
                    print("deleteCategoryList Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("deleteCategoryList error:", error)
            }
        }
    }

}
