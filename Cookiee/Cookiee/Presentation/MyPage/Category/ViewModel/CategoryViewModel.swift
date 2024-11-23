//
//  CategoryViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 11/24/24.
//

import SwiftUI

struct CategoryData : Codable {
    let categoryName: String
    let categoryColor: String
}

class CategoryViewModel: ObservableObject {
    @Published var category: CategoryData?
}
