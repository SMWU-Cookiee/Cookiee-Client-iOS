//
//  CookieeCollectionService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import Foundation
import Moya

class CookieeCollectionService {
    let provider = MoyaProvider<CookieeCollectionAPI>(session: Session(interceptor: TokenInterceptor.shared))
    
    private var userId: String

    init() {
        if let id = loadFromKeychain(key: "userId") {
            self.userId = id
        } else {
            self.userId = ""
            print("CookieeCollectionService init : userId를 찾을 수 없음")
        }
    }

    func getCookieeCollectionList(completion: @escaping (Result<CookieeCollectionListResponseDTO, Error>) -> Void) {
        provider.request(.getCookieeCollectionList(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(CookieeCollectionListResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("getCookieeCollectionList Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("getCookieeCollectionList error:", error)
            }
        }
    }
}
