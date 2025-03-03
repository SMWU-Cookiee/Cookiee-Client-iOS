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
    @ObservedObject var eventViewModel = EventViewModel()
    @State private var isEventDetailViewModalOpen: Bool = false
    @State private var isEventRemoved: Bool = false
    
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
                                    ThumbnailButtonToEventDetail(url: eventImage.firstImageUrl, cellWidth: cellWidth, eventId: eventImage.eventId)
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
        .sheet(isPresented: $isEventDetailViewModalOpen) {
            if eventViewModel.selectedEventId != nil {
                EventDetailView(eventViewModel: eventViewModel)
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(Visibility.visible)
            }
        }
        .onChange(of: isEventDetailViewModalOpen) {
            if eventViewModel.isRemoveSuccess {
                eventViewModel.isRemoveSuccess = false
                cookieeCollectionViewModel.loadCookieeCollectionDetailData(categoryId: id)
            }
        }
    }
    
    private func ThumbnailButtonToEventDetail(url: String, cellWidth: CGFloat, eventId: Int64) -> some View {
        Button(action: {
            print(eventId)
            eventViewModel.selectedEventId = eventId
            isEventDetailViewModalOpen = true
        }, label: {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cellWidth, height: cellWidth)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: cellWidth, height: cellWidth)
            }
        })
    }
}

#Preview {
    CookieeCollectionDetailView(id: 1)
}
