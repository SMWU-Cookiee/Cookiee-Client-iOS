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

    func getThumbnailList(userId: String, completion: @escaping (Result<ThumbnailListResponseDTO, Error>) -> Void) {
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
