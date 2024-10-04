//
//  deleteFromKeychain.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Security

// MARK: - 키체인에서 삭제
func deleteFromKeychain(key: String) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecAttrService as String: "Cookiee"
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    if status == errSecSuccess {
        print("deleteFromKeychain : \(key) 삭제 성공")
    } else {
        print("deleteFromKeychain : \(key) 삭제 실패")
    }
}
