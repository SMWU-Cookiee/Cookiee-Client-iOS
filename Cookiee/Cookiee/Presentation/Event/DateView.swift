//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = EventListViewModel()
    @State private var isModalOpen: Bool = false
    var date: Date?
    @State var thumbnailURL: String?

    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image("ChevronLeftIcon")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomLeading) {
                    HStack {
                        Image("testimage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: 265)
                            .clipped()
                    }
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(1.0), Color.white.opacity(0.6), .clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 40), alignment: .bottom
                    )
                    HStack {
                        Text("\(date!, formatter: Self.dateFormatter)")
                            .foregroundStyle(Color.Brown00)
                            .font(.Head0_B_22)
                    }
                    .padding(.leading, 7)
                }
                ScrollView {
                    EventCardGridView(eventList: viewModel.eventListData?.result ?? [], toggleModal: {
                        isModalOpen.toggle()
                    })
                }
                HStack {
                    NavigationLink(
                        destination: EventAddView(),
                        label: {
                            Text("쿠키 추가하기")
                                .foregroundStyle(Color.white)
                                .font(.Body0_SB)
                        }
                    )
                    .frame(width: 355, height: 44)
                    .background(Color.Brown00)
                    .cornerRadius(10)
                    .padding(.top, 3)
                }
            }
            .edgesIgnoringSafeArea(.top)
//            .overlay(
//                isModalOpen ?
//                Rectangle()
//                    .edgesIgnoringSafeArea(.all)
//                    .background(Color.Black)
//                    .opacity(0.5)
//                    .transition(.opacity.animation(.easeInOut(duration: 0.1)))
//                : nil
//            )
            .sheet(isPresented: $isModalOpen) {
                EventDetailView(eventId: "58", date: date ?? Date.now)
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(Visibility.visible)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            viewModel.loadEventListData()
        }
    }
}

extension DateView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
}

private struct EventCardGridView: View {
    var eventList: [Event]
    var toggleModal: () -> Void

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 7, alignment: .center), count: 2),
            spacing: 7
        ) {
            ForEach(eventList) { event in
                EventCardCellView(
                    thumbnailUrl: event.imageUrlList.first ?? "",
                    firstCategory: event.categories.first?.name ?? "",
                    firstCategoryColor: event.categories.first?.color ?? "#FFFFFF",
                    eventId: "\(event.id)",
                    toggleModal: toggleModal
                )
            }
        }
        .padding(.horizontal, 7)
    }
}


// API Response에서 이벤트 첫번째 사진, 첫번째 카테고리, eventId 추출
private func getFirstImageUrlAndCategory(from response: [String: Any]) -> [(imageUrl: String, category: [String: Any], eventId: String)]? {
    guard let resultArray = response["result"] as? [[String: Any]] else {
        return nil
    }

    var results: [(String, [String: Any], String)] = []

    for event in resultArray {
        if let eventId = event["eventId"] as? String,
           let imageUrlList = event["imageUrlList"] as? [String], let firstImageUrl = imageUrlList.first,
           let categories = event["categories"] as? [[String: Any]], let firstCategory = categories.first {
            results.append((imageUrl: firstImageUrl, category: firstCategory, eventId: eventId))
        }
    }

    return results
}
