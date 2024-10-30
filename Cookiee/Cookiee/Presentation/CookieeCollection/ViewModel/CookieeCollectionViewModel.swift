//
//  CookieeCollectionViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import Foundation

class CookieeCollectionViewModel: ObservableObject {
    @Published var cookieeCollectionList: [CookieeCollectionResultData] = []
    @Published var cookieeCollectionDetail: CookieeCollectionDetailResultData?
    
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
    
    func loadCookieeCollectionDetailData(categoryId: Int64) {
        cookieeService.getCookieeCollectionDetail(categoryId: categoryId) { result in
            switch result {
            case .success(let cookieeDetail):
                DispatchQueue.main.async {
                    self.cookieeCollectionDetail = cookieeDetail.result
                    print("✅ getCookieeCollectionDetail 성공")
                    print("🍎 getCookieeCollectionDetail 결과 : ", self.cookieeCollectionList)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

