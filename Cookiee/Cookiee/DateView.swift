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
                    Button {
                        // action
                    } label: {
                        Text("쿠키 추가하기")
                            .foregroundStyle(Color.white)
                            .font(.Body0_SB)
                    }
                    .frame(width: 355, height: 44)
                    .background(Color.Brown00)
                    .cornerRadius(10)
                    .padding(.top, 3)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $isModalOpen) {
                EventDetailView(eventId: "58")
                    .presentationDetents([.fraction(0.99)])
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            viewModel.loadEventListData()
        }
    }
}

#Preview {
    DateView(date: Date.now)
}

extension DateView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
}



// 이벤트 카드 셀
private struct EventCardCellView: View {
    private var thumbnailUrl: String
    private var firstCategory: String
    private var firstCategoryColor: Color
    private var eventId: String
    private var toggleModal: () -> Void
    
    fileprivate init(thumbnailUrl: String, firstCategory: String, firstCategoryColor: String, eventId: String, toggleModal: @escaping () -> Void) {
        self.thumbnailUrl = thumbnailUrl
        self.firstCategory = firstCategory
        self.firstCategoryColor = Color(hex: firstCategoryColor)
        self.eventId = eventId
        self.toggleModal = toggleModal
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button {
                toggleModal()
            } label: {
                ZStack {
                    AsyncImage(url: URL(string: thumbnailUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: .infinity, height: 240)
                        case .success(let image):
                            image
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(width: .infinity, height: 240)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(width: 185, height: 240)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .cornerRadius(5)
            }
            Label {
                Text("#" + firstCategory)
                    .font(.Body1_M)
                    .foregroundColor(.black)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(firstCategoryColor)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 1)
                    )
            } icon: {
                EmptyView()
            }
            .padding(.trailing, 8)
            .padding(.bottom, 8)
        }
        .frame(width: .infinity, height: 240)
    }
}



// 이벤트 카드 뷰
import SwiftUI

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
