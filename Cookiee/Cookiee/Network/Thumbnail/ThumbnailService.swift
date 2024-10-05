//
//  ThumbnailService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Moya

class ThumbnailService {
    let provider = MoyaProvider<ThumbnailAPI>(session: Session(interceptor: TokenInterceptor.shared))
    
    private var userId: String

    init() {
        if let id = loadFromKeychain(key: "userId") {
            self.userId = id
        } else {
            self.userId = ""
            print("CategoryService init : userId를 찾을 수 없음")
        }
    }

    func getThumbnailList(completion: @escaping (Result<ThumbnailListResponseDTO, Error>) -> Void) {
        provider.request(.getThumbnailList(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let thumbResponse = try JSONDecoder().decode(ThumbnailListResponseDTO.self, from: response.data)
                    completion(.success(thumbResponse))
                } catch {
                    completion(.failure(error))
                    print("getThumbnailList Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("getThumbnailList error:", error)
            }
        }
    }
}
