//
//  CookieeCollectionViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import Foundation

class CookieeCollectionViewModel: ObservableObject {
    @Published var cookieeCollectionList: [CookieeCollectionResultData] = []
    
    let cookieeService = CookieeCollectionService()
    
    func loadCookieeCollectionListData() {
        cookieeService.getCookieeCollectionList() { result in
            switch result {
            case .success(let cookieeList):
                DispatchQueue.main.async {
                    self.cookieeCollectionList = cookieeList.result
                    print("✅ loadCookieeListData 성공")
                    print("🍎 loadCookieeListData 결과 : ", self.cookieeCollectionList)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

