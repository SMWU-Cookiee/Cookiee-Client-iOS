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
    
    @ObservedObject private var eventViewModel = EventViewModel()
    @ObservedObject private var thumbnailViewModel = ThumbnailViewModel()
    @State private var isEventDetailViewModalOpen: Bool = false
    @State private var isThumbnailPutOrDeleteModalOpen: Bool = false
    @State var isRegisterImageModalOpen: Bool = false
    @State var isUpdateImageModalOpen: Bool = false
    
    @State var selectedEventId: Int64?
    
    var date: Date
    var calendar = Calendar.current
    var yearOfEvent : Int32 { Int32(calendar.component(.year, from: date)) }
    var monthOfEvent : Int32 { Int32(calendar.component(.month, from: date)) }
    var dayOfEvent : Int32 { Int32(calendar.component(.day, from: date)) }

    @State var thumbnailId: Int64?
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var newImage: UIImage?
    
    
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
                                isRegisterImageModalOpen = true
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
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 7, alignment: .center), count: 2),
                        spacing: 7
                    ) {
                        ForEach(eventViewModel.eventListForCell) { event in
                            EventCardCellView(
                                eventViewModel: eventViewModel,
                                thumbnailUrl: event.firstEventImage,
                                firstCategory: event.firstCategory.categoryName,
                                firstCategoryColor: event.firstCategory.categoryColor,
                                eventId: event.eventId,
                                toggleModal: {
                                    isEventDetailViewModalOpen.toggle()
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 7)
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
                if eventViewModel.selectedEventId != nil {
                    EventDetailView(eventId: eventViewModel.selectedEventId!, date: date)
                        .presentationDetents([.fraction(0.99)])
                        .presentationDragIndicator(Visibility.visible)
                }
            }
            .sheet(isPresented: $isThumbnailPutOrDeleteModalOpen) {
                VStack(spacing: 0) {
                    Text("썸네일")
                        .font(.Head1_B)
                    
                    Button(action: {
                        isUpdateImageModalOpen = true
                        showImagePicker = true
                        isThumbnailPutOrDeleteModalOpen = false
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
                        thumbnailViewModel.removeThumbnail(thumbnailId: thumbnailId!.description)
                        isThumbnailPutOrDeleteModalOpen = false
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
            .sheet(isPresented: $showImagePicker, onDismiss: {
                showImagePicker = false
                loadImage()
            }) {
                ImagePicker(image: $selectedUIImage)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            eventViewModel.loadEventList(
                year: yearOfEvent,
                month: monthOfEvent,
                day: dayOfEvent
            )
            if (thumbnailId != nil) {
                thumbnailViewModel.loadThumbnilByDate(
                    year: yearOfEvent,
                    month: monthOfEvent,
                    day: dayOfEvent
                )
            }
        }
        .onChange(of: newImage) {
            if newImage != nil {
                if isRegisterImageModalOpen {
                    thumbnailViewModel.registerThumbnail(
                        year: yearOfEvent,
                        month: monthOfEvent,
                        day: dayOfEvent,
                        thumbnailImage: newImage!
                    )
                    isRegisterImageModalOpen = false
                } else if isUpdateImageModalOpen {
                    thumbnailViewModel.updateThumbnail(
                        thumbnailId: thumbnailId!.description,
                        newThumbnail: newImage!
                    )
                    isUpdateImageModalOpen = false
                }
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



#Preview {
    DateView(date: Date.now)
}
