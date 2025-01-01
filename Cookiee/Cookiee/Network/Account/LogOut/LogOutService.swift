//
//  LogOutService.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/24/24.
//

import Foundation
import Moya

class LogOutService {
    let provider = MoyaProvider<LogOutAPI>()
    
    func putLogOut(completion: @escaping (Result<LogOutResponseDTO, Error>) -> Void) {
        provider.request(.putLogOut) { result in
            switch result {
            case .success(let response):
                do {
                    let res = try JSONDecoder().decode(LogOutResponseDTO.self, from: response.data)
                    completion(.success(res))
                } catch {
                    completion(.failure(error))
                    print("putLogOut Decoding error:", error)
                }
            case .failure(let error):
                if let response = error.response {
                    print("putLogOut Response Data:", String(data: response.data, encoding: .utf8) ?? "No response body")
                }
                completion(.failure(error))
                print("putLogOut error:", error)
            }
        }
    }
}

