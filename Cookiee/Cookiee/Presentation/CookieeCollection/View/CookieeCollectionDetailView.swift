//
//  CookieeCollectionDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import SwiftUI

struct CookieeCollectionDetailView: View {
    @ObservedObject var cookieeCollectionViewModel = CookieeCollectionViewModel()
    
    var id: Int64
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / 3 - 1
            
            VStack {
                if let cookieeCollectionDetail = cookieeCollectionViewModel.cookieeCollectionDetail {
                    if cookieeCollectionDetail.eventImageList.isEmpty {
                        Text("등록된 이벤트가 없어요!")
                    } else {
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(cookieeCollectionDetail.eventImageList, id: \.eventId) { eventImage in
                                AsyncImage(url: URL(string: eventImage.firstImageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: cellWidth, height: cellWidth)
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: cellWidth, height: cellWidth)
                                }
                            }
                        }
                        .padding(.horizontal, 1)
                        
                        Spacer()
                    }
                } else {
                    Text("모아보기 데이터를 불러올 수 없습니다.")
                }
            }
            .onAppear {
                cookieeCollectionViewModel.loadCookieeCollectionDetailData(categoryId: id)
            }
        }
    }
}

#Preview {
    CookieeCollectionDetailView(id: 1)
}

