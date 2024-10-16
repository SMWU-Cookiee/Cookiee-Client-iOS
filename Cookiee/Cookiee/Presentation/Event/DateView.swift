//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    
    @StateObject private var viewModel = EventListViewModel()
    @ObservedObject private var thumbnailViewModel = ThumbnailViewModel()
    @State private var isEventDetailViewModalOpen: Bool = false
    @State private var isThumbnailPutOrDeleteModalOpen: Bool = false
    
    var date: Date

    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var newImage: UIImage?
    @State var thumbnailId: Int64?
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        newImage = selectedImage
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomLeading) {
                    HStack {
                        if !thumbnailViewModel.thumbnail.isEmpty {
                            Button(action: {
                                isThumbnailPutOrDeleteModalOpen = true
                            }, label: {
                                AsyncImage(url: URL(string: thumbnailViewModel.thumbnail)) { phase in
                                    switch phase {
                                    case .empty:
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white)
                                            .frame(width: geometry.size.width, height: 265)
                                            .overlay(ProgressView())
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width, height: 265)
                                            .clipped()
                                        
                                    case .failure(_):
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundStyle(Color.gray)
                                            )
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            })
                        } else {
                            Button(action: {
                                print("썸네일 추가")
                                showImagePicker = true
                            }, label: {
                                VStack(alignment: .center) {
                                    Image("ThumbnailPhoto")
                                        .frame(width: 31, height: 31)
                                        .padding(.vertical, 7)
                                    Text("탭하여 썸네일 추가하기")
                                        .font(.Body1_M)
                                        .foregroundStyle(Color.Gray05)
                                }
                                .frame(width: geometry.size.width, height: 265)
                                .background(Color.Gray01)
                            })
                        }
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
                        Text("\(date, formatter: Self.dateFormatter)")
                            .foregroundStyle(Color.Brown00)
                            .font(.Head0_B_22)
                    }
                    .padding(.leading, 7)
                }
                ScrollView {
                    EventCardGridView(eventList: viewModel.eventListData?.result ?? [], toggleModal: {
                        isEventDetailViewModalOpen.toggle()
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
            .sheet(isPresented: $isEventDetailViewModalOpen) {
                EventDetailView(eventId: "58", date: date)
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(Visibility.visible)
            }
            .sheet(isPresented: $isThumbnailPutOrDeleteModalOpen) {
                VStack(spacing: 0) {
                    Text("썸네일")
                        .font(.Head1_B)
                    
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image("EditIcon")
                            Text("수정하기")
                                .font(.Body0_M)
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                    })
                    .frame(height: 44)
                    .padding(.top, 10)
                    
                    Divider()
                    
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image("TrashIconRed")
                            Text("삭제하기")
                                .font(.Body0_M)
                                .foregroundStyle(Color.Error)
                            Spacer()
                        }
                    })
                    .frame(height: 44)

                    Divider()
                    
                    Button(action: {
                        isThumbnailPutOrDeleteModalOpen = false
                    }, label: {
                        HStack {
                            Image("XmarkIcon")
                            Text("취소")
                                .font(.Body0_M)
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                    })
                    .frame(height: 40)

                }
                .padding()
                .presentationDetents([.fraction(0.27)])
                .presentationDragIndicator(Visibility.visible)
            }
//            .sheet(isPresented: $showImagePicker, onDismiss: {
//                showImagePicker = false
//                loadImage()
//            }) {
//                ImagePicker(image: $selectedUIImage)
//            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            viewModel.loadEventListData()
            if (thumbnailId != nil) {
                let calendar = Calendar.current
                thumbnailViewModel.loadThumbnilByDate(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date))
            }
        }
        .onChange(of: newImage) {
            print("🔥 newImage 변경 감지")
            if newImage != nil {
                let calendar = Calendar.current
                
                thumbnailViewModel.registerThumbnail(
                    year: calendar.component(.year, from: date),
                    month: calendar.component(.month, from: date),
                    day: calendar.component(.day, from: date),
                    thumbnailImage: newImage!
                )
            }
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

#Preview {
    DateView(date: Date.now)
}
