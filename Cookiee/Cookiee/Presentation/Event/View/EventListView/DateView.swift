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
    
    @StateObject private var eventViewModel = EventViewModel()
    @StateObject private var thumbnailViewModel = ThumbnailViewModel()
    @State private var isEventDetailViewModalOpen: Bool = false
    @State private var isThumbnailDetailModalOpen: Bool = false
    @State private var isThumbnailPutOrDeleteModalOpen: Bool = false
    @State var isRegisterImageModalOpen: Bool = false
    @State var isUpdateImageModalOpen: Bool = false
        
    var date: Date
    let calendar = Calendar.current
    var yearOfEvent : Int32 { Int32(calendar.component(.year, from: date)) }
    var monthOfEvent : Int32 { Int32(calendar.component(.month, from: date)) }
    var dayOfEvent : Int32 { Int32(calendar.component(.day, from: date)) }

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
                        if thumbnailViewModel.thumbnailData != nil {
                            ZStack {
                                if !thumbnailViewModel.isLoading {
                                    Button(action: {
                                        isThumbnailDetailModalOpen = true
                                    }, label: {
                                            AsyncImage(url: URL(string: thumbnailViewModel.thumbnailData!.thumbnailUrl)) { phase in
                                                switch phase {
                                                case .empty:
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(Color.Gray01)
                                                        .frame(width: geometry.size.width, height: 265)
                                                        .overlay(ProgressView())
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: geometry.size.width, height: 265)
                                                        .clipped()
                                                case .failure(_):
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(Color.Gray01)
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
                                }
                                
                                
                                if thumbnailViewModel.isLoading {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.Gray01)
                                        .frame(width: geometry.size.width, height: 265)
                                        .overlay(ProgressView())
                                }
                            }
                        } else {
                            Button(action: {
                                isRegisterImageModalOpen = true
                                showImagePicker = true
                            }, label: {
                                VStack(alignment: .center) {
                                    Image("ImageBrown")
                                        .frame(width: 31, height: 31)
                                        .padding(.vertical, 7)
                                    Text("탭하여 썸네일 추가하기")
                                        .font(.Body1_M)
                                        .foregroundStyle(Color.Brown02)
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
                    VStack(alignment: .center){
                        LazyVGrid(
                            columns:
                                Array(repeating:
                                        GridItem(
                                            .flexible(),
                                            alignment: .center
                                        ),
                                          count: 2
                                     )
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
                                    },
                                    width: geometry.size.width / 2 - 14
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 7)
                
                HStack {
                    NavigationLink(
                        destination: EventAddView(year: yearOfEvent, month: monthOfEvent, date: dayOfEvent),
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
            .fullScreenCover(isPresented: $isThumbnailDetailModalOpen) {
                ZStack {
                    VStack {
                        Spacer()
                        VStack {
                            AsyncImage(url: URL(string: thumbnailViewModel.thumbnailData!.thumbnailUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: geometry.size.width)
                                case .failure(_):
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isThumbnailPutOrDeleteModalOpen = true
                            }, label: {
                                Image("MenuIcon")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            })
                        }
                    }
                    .padding(15)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .onTapGesture {
                    isThumbnailDetailModalOpen = false
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
                            if thumbnailViewModel.thumbnailData != nil {
                                thumbnailViewModel.isLoading = true
                                thumbnailViewModel.removeThumbnail(thumbnailId: (thumbnailViewModel.thumbnailData!.thumbnailId.description), year: yearOfEvent, month: monthOfEvent, day: dayOfEvent)
                                thumbnailViewModel.isLoading = false
                                isThumbnailPutOrDeleteModalOpen = false
                                isThumbnailDetailModalOpen = false
                            }
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
                    isThumbnailPutOrDeleteModalOpen = false
                    isThumbnailDetailModalOpen = false
                    loadImage()
                }) {
                    ImagePicker(image: $selectedUIImage)
                }
            }
            
        }
        .sheet(isPresented: $isEventDetailViewModalOpen, onDismiss: {
            eventViewModel.loadEventList(
                year: yearOfEvent,
                month: monthOfEvent,
                day: dayOfEvent
            )
        }) {
            if eventViewModel.selectedEventId != nil {
                EventDetailView(eventViewModel: eventViewModel)
                    .presentationDetents([.fraction(0.99)])
                    .presentationDragIndicator(Visibility.visible)
                    .onDisappear() {
                        eventViewModel.isRemoveSuccess = false
                    }
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            showImagePicker = false
            isThumbnailPutOrDeleteModalOpen = false
            isThumbnailDetailModalOpen = false
            loadImage()
        }) {
            ImagePicker(image: $selectedUIImage)
        }
        

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            eventViewModel.loadEventList(
                year: yearOfEvent,
                month: monthOfEvent,
                day: dayOfEvent
            )
            thumbnailViewModel.loadThumbnilByDate(
                year: yearOfEvent,
                month: monthOfEvent,
                day: dayOfEvent
            )
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
                        thumbnailId: thumbnailViewModel.thumbnailData!.thumbnailId.description,
                        newThumbnail: newImage!,
                        year: yearOfEvent, month: monthOfEvent, day: dayOfEvent
                    )
                    isUpdateImageModalOpen = false
                }
            }
        }
        .navigationDestination(
            isPresented: $eventViewModel.isEditButtonTapped,
            destination: {
                EventEditView(eventViewModel: eventViewModel)
        })
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
