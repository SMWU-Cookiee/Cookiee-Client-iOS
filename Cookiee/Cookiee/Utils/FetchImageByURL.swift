//
//  FetchImageByURL.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/17/24.
//

import SwiftUI

func fetchImageByURL(url: String) -> some View {
    AsyncImage(url: URL(string: url)) { phase in
        switch phase {
        case .success(let image):
            image
                .resizable()
                .scaledToFit()
        default:
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}
