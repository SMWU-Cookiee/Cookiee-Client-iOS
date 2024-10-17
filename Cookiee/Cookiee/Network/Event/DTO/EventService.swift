//
//  EventService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/17/24.
//

import Foundation
import Moya

class EventService {
    let provider = MoyaProvider<EventAPI>(session: Session(interceptor: TokenInterceptor.shared))
    
    private var userId: String

    init() {
        if let id = loadFromKeychain(key: "userId") {
            self.userId = id
        } else {
            self.userId = ""
            print("EventService init : userId를 찾을 수 없음")
        }
    }

    func getEventList(year: Int32, month:Int32, day: Int32, completion: @escaping (Result<EventListResponseDTO, Error>) -> Void) {
        provider.request(.getEventList(userId: userId, year: year, month: month, day: day)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(EventListResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("getEventList Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("getEventList error:", error)
            }
        }
    }
    
    func getEventDetail(eventId: Int64, completion: @escaping (Result<EventDetailResponseDTO, Error>) -> Void) {
        provider.request(.getEventDetail(userId: userId, eventId: eventId)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(EventDetailResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("getEventDetail Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("getEventDetail error:", error)
            }
        }
    }
}
