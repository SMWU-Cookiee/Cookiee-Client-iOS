//
//  CategorySelectViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/20/24.
//

import Foundation

class CategorySelectViewModel: ObservableObject {
    
    @Published var countOfSelectedCategory: Int = 0
    
    func isAnyCategorySelected() -> Bool {
        countOfSelectedCategory > 0
    }
}
