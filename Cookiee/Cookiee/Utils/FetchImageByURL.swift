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
            VStack(alignment: .center) {
                Spacer()
                image
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            
        default:
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .frame(width: 350, height: 300)
            .background(Color.white)
        }
    }
}
