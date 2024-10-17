//
//  EventDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/15/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject private var eventViewModel = EventViewModel()
    @State var eventId: Int64
    @State var date: Date
    
    @State private var currentIndex: Int = 0
    @State private var imageList: [String] = []
    
    @State private var isDeleteButtonTapped: Bool = false

    var body: some View {
        VStack {
            VStack {
                if eventViewModel.eventDetail != nil {
                    HStack (alignment: .bottom) {
                        Text("\(date, formatter: Self.dateFormatter)")
                            .font(.Head1_B)
                        Spacer()
                        HStack {
                            Button {
                            } label: {
                                Image("EditIcon")
                            }
                            Button {
                                isDeleteButtonTapped = true
                            } label: {
                                Image("TrashIcon")
                            }
                        }
                    }
                    .padding(20)
                    .padding(.top, 23)

                    
                    HStack {
                        ImageCarouselView(
                            index: $currentIndex,
                            imageUrls: eventViewModel.eventDetail!.eventImageUrlList
                        )
                            .frame(height: 365)
                    }
                    
                    VStack {
                        Text(eventViewModel.eventDetail!.title)
                            .font(.Body0_SB)
                        HStack {
                            ForEach(eventViewModel.eventDetail!.categories, id: \.categoryId) { category in
                                CategoryLabel(
                                    name: category.categoryName,
                                    color: category.categoryColor
                                )
                                .padding(.horizontal, 1)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                    .padding(.top, 15)
                    
                    ScrollView {
                        VStack (alignment: .leading) {
                            EventInfoDetailView(
                                title: "장소",
                                decription: eventViewModel.eventDetail!.eventWhere
                            )
                            EventInfoDetailView(
                                title: "내용",
                                decription: eventViewModel.eventDetail!.what
                            )
                            EventInfoDetailView(
                                title: "함께한 사람",
                                decription: eventViewModel.eventDetail!.withWho
                            )
                        }
                    }
                    .padding(.horizontal, 15)
 
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            Spacer()
        }
    
        .showCustomAlert(
            isPresented: $isDeleteButtonTapped,
            content: {
                    VStack {
                        Text(eventViewModel.eventDetail!.title)
                            .font(.Head1_B)
                            .foregroundStyle(Color.Brown01)
                        Text("쿠키를 삭제할까요?")
                            .font(.Head1_B)
                            .padding(.bottom, 9)
                        Text("삭제하면 복구가 어렵습니다.")
                            .font(.Body1_R)
                    }
            },
            firstButton:
                CustomAlertButton(
                    action: { isDeleteButtonTapped = false },
                    title: Text("취소").foregroundColor(Color.Gray04)
                ),
            secondButton:
                CustomAlertButton(
                    action: {
                        isDeleteButtonTapped = false
                        eventViewModel.removeEvent(eventId: eventId)
                    },
                    title: Text("삭제하기").foregroundColor(Color.Brown00))
        )
        
        .onAppear() {
            eventViewModel.loadEventDetail(eventId: eventId)
        }
        .onChange(of: eventViewModel.isRemoveSuccess) {
            if eventViewModel.isRemoveSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension EventDetailView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}

struct EventInfoDetailView: View {
    let title: String
    let decription: String

    var body: some View {
        VStack (alignment: .leading) {
            HStack{
                Image("CookieeIcon_fill")
                Text(title)
                    .font(.Body1_R)
                    .foregroundStyle(Color.Brown01)
            }
            
            HStack {
                Text(decription)
                    .font(.Body1_R)
                    .padding(10)
                    .background(Color.Beige)
                    .cornerRadius(12)
                    .frame(alignment: .leading)
            }
        }
        .padding(.bottom, 7)
    }
}

#Preview {
    EventDetailView(eventId: 58, date: Date.now)
}
