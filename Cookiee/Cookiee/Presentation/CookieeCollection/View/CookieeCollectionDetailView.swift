//
//  CookieeCollectionDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import SwiftUI

struct CookieeCollectionDetailView: View {
    var id: Int64
    
    var body: some View {
        Text("Hello, \(id)!")
    }
}

#Preview {
    CookieeCollectionDetailView(id: 1)
}
