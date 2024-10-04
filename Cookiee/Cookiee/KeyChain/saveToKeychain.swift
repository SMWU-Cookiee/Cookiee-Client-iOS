//
//  saveToKeychain.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Security

// MARK: - 키체인에 저장
func saveToKeychain(key: String, data: String) {
    if let data = data.data(using: .utf8) {
        // 먼저 기존 데이터를 삭제
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "Cookiee"
        ]
        SecItemDelete(query as CFDictionary)
        
        // 새 데이터를 저장
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "Cookiee",
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        if status == errSecSuccess {
            print("saveToKeychain : \(key) 저장 성공")
        } else {
            print("saveToKeychain : \(key) 저장 실패")
        }
    }
}
