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
                if let response = error.response {
                    print("getEventDetail Response Data: \n", String(data: response.data, encoding: .utf8) ?? "No response body")
                }
                completion(.failure(error))
                print("getEventDetail error:", error)
            }
        }
    }
    
    
    func postEvent(requestBody: EventRequestDTO, completion: @escaping (Result<EventDetailResponseDTO, Error>) -> Void) {
        provider.request(.postEvent(userId: userId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(EventDetailResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    print("postEvent Decoding error:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("postEvent error:", error)
                if let response = error.response {
                    print("Response Data:", String(data: response.data, encoding: .utf8) ?? "No response body")
                }
                completion(.failure(error))
            }
        }

    }
    
    func putEvent(eventId: Int64, requestBody: EventRequestDTO, completion: @escaping (Result<EventDetailResponseDTO, Error>) -> Void) {
        provider.request(.putEvent(userId: userId, eventId: eventId, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(EventDetailResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("putEvent Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("putEvent error:", error.errorDescription as Any)
            }
        }
    }
    
    func deleteEvent(eventId: Int64, completion: @escaping (Result<EventDeleteDTO, Error>) -> Void) {
        provider.request(.deleteEvet(userId: userId, eventId: eventId)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(EventDeleteDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("deleteEvent Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("deleteEvent error:", error)
            }
        }
    }
}
