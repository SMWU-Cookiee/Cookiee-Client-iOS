//
//  ProfileService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation
import Moya

class ProfileService {
    let provider = MoyaProvider<ProfileAPI>(session: Session(interceptor: TokenInterceptor.shared))
    
    private var userId: String
    
    init() {
        if let id = loadFromKeychain(key: "userId") {
            self.userId = id
            print("ProfileService init : userId = \(userId)")
        } else {
            self.userId = ""
            print("ProfileService init : userId를 찾을 수 없음")
        }
    }
    
    func getProfile(completion: @escaping (Result<ProfileResponseDTO, Error>) -> Void) {
        provider.request(.getUserProfile(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    print(String(data: response.data, encoding: .utf8) ?? "No response data")
                    let profileResponse = try JSONDecoder().decode(ProfileResponseDTO.self, from: response.data)
                    completion(.success(profileResponse))
                } catch {
                    completion(.failure(error))
                    print("❌ getProfile Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("❌ getProfile error:", error)
            }
        }
    }
    
    func putProfile(requestBody: ProfilePutRequestDTO, completion: @escaping (Result<ProfileResponseDTO, Error>) -> Void) {
        provider.request(.putUserProfile(userId: userId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    print(String(data: response.data, encoding: .utf8) ?? "No response data")
                    let response = try JSONDecoder().decode(ProfileResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("❌ putUserProfile Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("❌ putUserProfile error:", error.errorDescription as Any)
            }
        }
    }
}
