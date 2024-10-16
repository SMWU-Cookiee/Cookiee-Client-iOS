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
            print("ThumbnailService init : userId를 찾을 수 없음")
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
    
    func postThumbnail(requestBody: ThumbnailRequestDTO, completion: @escaping (Result<ThumbnailResponseDTO, Error>) -> Void) {
        provider.request(.postThumbnail(userId: userId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(ThumbnailResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("postThumbnail Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("postThumbnail error:", error.errorDescription as Any)
            }
        }
    }
    
    func getThumbnailByDate(year: Int, month: Int, day: Int, completion: @escaping (Result<ThumbnailResponseDTO, Error>) -> Void) {
        provider.request(.getTumbnailByDate(userId: userId, year: year, month: month, day: day)) { result in
            switch result {
            case .success(let response):
                do {
                    let thumbResponse = try JSONDecoder().decode(ThumbnailResponseDTO.self, from: response.data)
                    completion(.success(thumbResponse))
                } catch {
                    completion(.failure(error))
                    print("getThumbnailByDate Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("getThumbnailByDate error:", error)
            }
        }
    }
    
    func deleteThumbnail(thumbnailId: String, completion: @escaping (Result<ThumbnailDeleteResponseDTO, Error>) -> Void) {
        provider.request(.deleteThumbnail(userId: userId, thumbnailId: thumbnailId)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(ThumbnailDeleteResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("deleteThumbnail Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("deleteThumbnail error:", error)
            }
        }
    }
}
