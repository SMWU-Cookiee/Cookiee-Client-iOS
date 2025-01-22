//
//  GoogleLoginService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/1/24.
//

import Foundation
import Moya

class GoogleLoginService {
    let provider = MoyaProvider<GoogleLoginAPI>()
    
    func getGoogleLogin(socialId: String, completion: @escaping (Result<GoogleLoginResponseDTO, Error>) -> Void) {
        provider.request(.getGoogleLogin(socialId: socialId)) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(GoogleLoginResponseDTO.self, from: response.data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                    print("getGoogleLogin Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                if let data = error.response?.data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Error response data: \(responseString ?? "No Data")")
                }
                print("getGoogleLogin error:", error)
            }
        }
    }
}
