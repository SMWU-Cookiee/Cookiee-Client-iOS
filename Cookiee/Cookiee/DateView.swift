//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    // Back 버튼 커스텀
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backButton : some View {
            Button{
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image("ChevronLeftIcon")
                        .aspectRatio(contentMode: .fit)
                }
            }
        }

    var date: Date?
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
                            gradient: Gradient(colors: [Color.white.opacity(1.0), Color.white.opacity(0.6), .clear]), startPoint: .bottom, endPoint: .top
                        )
                        .frame(height: 40), alignment: .bottom)
                    HStack {
                        Text("\(date!, formatter: Self.dateFormatter)")
                            .foregroundStyle(Color.Brown00)
                            .font(.Head0_B_22)
                    }
                    .padding(.leading, 7)
                    
                }
                ScrollView {
                    EventCardGridView
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
        }
        .navigationBarBackButtonHidden(true) // Back 버튼 커스텀
        .navigationBarItems(leading: backButton)
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
    private var first_category: String
    private var first_category_color: String
    
    fileprivate init(thumbnailUrl: String, first_category: String, first_category_color: String) {
        self.thumbnailUrl = thumbnailUrl
        self.first_category = first_category
        self.first_category_color = first_category_color
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.Beige)
                .overlay(
                    AsyncImage(url: URL(string: thumbnailUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
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
                )
            Label {
                Text("#" + first_category)
                    .font(.Body1_M)
                    .foregroundColor(.black)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(Color(hex: first_category_color))
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
private var EventCardGridView: some View {
    let card_data = getFirstImageUrlAndCategory(from: EventDataSample) ?? []

    return LazyVGrid(
        columns: Array(repeating: GridItem(.flexible(), spacing: 7, alignment: .center), count: 2),
        spacing: 7
    ) {
        ForEach(card_data.indices, id: \.self) { index in
            let data = card_data[index]
            EventCardCellView(thumbnailUrl: data.imageUrl,
                              first_category: data.category["categoryName"] as? String ?? "",
                              first_category_color: data.category["categoryColor"] as? String ?? "")
        }
    }
    .padding(.horizontal, 7)
}

// API Response에서 이벤트 첫번째 사진, 첫번째 카테고리 추출
private func getFirstImageUrlAndCategory(from response: [String: Any]) -> [(imageUrl: String, category: [String: Any])]? {
    guard let resultArray = response["result"] as? [[String: Any]] else {
        return nil
    }
    
    var results: [(String, [String: Any])] = []
    
    for event in resultArray {
        if let imageUrlList = event["imageUrlList"] as? [String], let firstImageUrl = imageUrlList.first,
           let categories = event["categories"] as? [[String: Any]], let firstCategory = categories.first {
            results.append((imageUrl: firstImageUrl, category: firstCategory))
        }
    }
    
    return results
}

