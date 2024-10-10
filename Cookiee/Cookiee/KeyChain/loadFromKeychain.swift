//
//  loadFromKeychain.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Security

// MARK: - 키체인에서 데이터를 불러오기
func loadFromKeychain(key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecAttrService as String: "Cookiee",
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var item: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess {
        if let data = item as? Data, let result = String(data: data, encoding: .utf8) {
            print("loadFromKeychain : \(key)=\(result) 불러오기 성공")
            return result
        }
    } else {
        print("loadFromKeychain : \(key) 불러오기 실패")
    }
    return nil
}
