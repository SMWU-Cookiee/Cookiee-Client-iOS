//
//  CookieeCollectionDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import SwiftUI

struct CookieeCollectionDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image("ChevronLeftIconBlack")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
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
                        VStack(alignment: .center) {
                            
                            Image("CookieeWithQuestionMark")
                                .frame(width: 74, height: 74)
                                .padding(.top, geometry.size.height / 3)
                                
                            Text("등록된 이벤트가 없어요!")
                                .font(Font.Body0_B)
                                .foregroundStyle(Color.Brown00)
                                .padding(.top, 13)
                            
                            Text("동기들 카테고리로 이벤트를 등록해서 쿠키를 모아보세요!")
                                .font(Font.Body1_M)
                                .foregroundStyle(Color.Brown03)
                                .padding(.top, 1)
                                
                        }
                        .frame(width: geometry.size.width)
                    } else {
                        ScrollView {
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
                    }
                } else {
                    Text("모아보기 데이터를 불러올 수 없습니다.")
                }
            }
            .padding(.top, 12)
            .onAppear {
                cookieeCollectionViewModel.loadCookieeCollectionDetailData(categoryId: id)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text((cookieeCollectionViewModel.cookieeCollectionDetail?.category.categoryName ?? "") + " 쿠키")
                    .font(.Head1_B)
                    .foregroundStyle(Color.Brown00)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}

#Preview {
    CookieeCollectionDetailView(id: 1)
}
