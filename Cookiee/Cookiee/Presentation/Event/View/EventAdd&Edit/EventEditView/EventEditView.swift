//
//  EventUpdateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import SwiftUI
import PhotosUI

struct EventEditView: View {
    @State var isBackButtonTapped: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 백 버튼 커스텀
    var backButton: some View {
        Button {
            self.isBackButtonTapped = true
        } label: {
            HStack {
                Image("ChevronLeftIconBlack")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    @State var title: String = ""
    @State var content: String = ""
    @State var people: String = ""
    @State var placeText: String = ""
    @State var place: EventWherePlace?
    
    @State var isCategorySelectButtonTapped: Bool = false
    
    @ObservedObject var eventViewModel: EventViewModel
    @ObservedObject var categoryListViewModel = CategoryListViewModel()
    @StateObject var categorySelectViewModel = CategorySelectViewModel()
    @StateObject var imagePickerForEventViewModel = ImagePickerForEventViewModel()
    @StateObject var imageViewModelForPut = ImageViewModelForPut()
    @ObservedObject var locationSearchService = EventMapLocationSearchViewModel()
    
    @State var maxImageCount: Int = 5
    @State var isSubmitting: Bool = false
    
    @FocusState private var isFocused: Bool
    @State var isEditSuccess: Bool = false
    @State var isInitialDataLoaded: Bool = false
    
    var isValidForm: Bool {
        !title.isEmpty &&
        !content.isEmpty &&
        !people.isEmpty &&
        !categorySelectViewModel.selectedCategory.isEmpty &&
        (imageViewModelForPut.uiImageList.count + imagePickerForEventViewModel.selection.count > 0) &&
        (placeText.isEmpty == false || place != nil)
    }
    
    var body: some View {
        ZStack {
            contentScrollView
                .padding(.top, 10)
            submittingOverlay
        }
        .onAppear() {
            if !isInitialDataLoaded {
                loadInitialData()
            }
        }
        .onTapGesture {
            isFocused = false
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            toolbarItems
        }
        
        .sheet(isPresented: $isCategorySelectButtonTapped) {
            CategorySelectBottomModal(
                categoryListViewModel: categoryListViewModel,
                categorySelectViewModel: categorySelectViewModel,
                isCategorySelectButtonTapped: $isCategorySelectButtonTapped
            )
        }
        
        .photosPicker(
            isPresented: $imagePickerForEventViewModel.isPhotoPickerPresented,
            selection: $imagePickerForEventViewModel.selection,
            maxSelectionCount: maxImageCount - imageViewModelForPut.uiImageList.count,
            selectionBehavior: .continuousAndOrdered,
            matching: .images,
            preferredItemEncoding: .current,
            photoLibrary: .shared()
        )
        .photosPickerStyle(.presentation)
        
        .onChange(of: eventViewModel.isUpdateSuccess) {
            if eventViewModel.isUpdateSuccess {
                eventViewModel.isUpdateSuccess = false
                isEditSuccess = true
            }
        }
        
        .showCustomAlert(
            isPresented: $isBackButtonTapped,
            alertContent: {
                VStack(alignment: .center) {
                    Text("쿠키 수정을 그만할까요?")
                        .font(Font.Head1_B)
                        .padding(.bottom, 9)
                    Text("지금까지 변경사항은 저장되지 않습니다.")
                        .font(Font.Body1_R)
                }
            },
            firstButton:
                CustomAlertButton(
                    action: { isBackButtonTapped = false },
                    title: Text("취소").foregroundColor(Color.Gray04)
                ),
            secondButton:
                CustomAlertButton(
                    action: {
                        isBackButtonTapped = false
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    title: Text("확인").foregroundColor(Color.Brown00))
        )
    }
    
    private var contentScrollView: some View {
        ScrollView {
            VStack {
                ImageCarouselForUIImage(imagePickerForEventViewModel: imagePickerForEventViewModel, imageViewModelForPut: imageViewModelForPut)
            }
            .padding(.bottom, 14)
            
            EventFormFields(
                title: $title,
                placeText: $placeText,
                content: $content,
                people: $people,
                place: $place,
                categorySelectViewModel: categorySelectViewModel,
                isCategorySelectButtonTapped: $isCategorySelectButtonTapped,
                locationSearchService: locationSearchService
            )
        }
    }
    
    private var submittingOverlay: some View {
        Group {
            if isSubmitting {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack {
                        if isEditSuccess {
                            successAlert
                        } else {
                            progressIndicator
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1)
                }
                .zIndex(2)
            }
        }
    }

    private var progressIndicator: some View {
        Group {
            Spacer()
            ProgressView()
                .controlSize(.large)
            Spacer()
        }
    }

    private var successAlert: some View {
        Group {
            Spacer()
            CustomAlertView(
                content: VStack(alignment: .center) {
                    Text("쿠키를 성공적으로 수정했습니다!")
                        .font(Font.Head1_B)
                        .padding(.bottom, 9)
                    Text("해당 날짜 캘린더에서 확인할 수 있어요.")
                        .font(Font.Body1_R)
                },
                firstButton: CustomAlertButton(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    title: Text("확인")
                        .font(Font.Body0_B)
                        .foregroundColor(Color.Brown00)
                ),
                secondButton: nil
            )
            Spacer()
        }
    }
    
    private var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                Text("쿠키 수정하기")
                    .font(.Head1_B)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSubmitting = true
                    updateEvent()
                }, label: {
                    Text("완료")
                        .font(.Body0_B)
                        .foregroundColor(isValidForm ? .Brown01 : .Gray03)
                })
                .disabled(!isValidForm || isSubmitting)
            }
        }
    }
}

extension EventEditView {
    func loadInitialData() {
        eventViewModel.loadEventDetail(eventId: eventViewModel.selectedEventId!)
        
        if let eventDetail = eventViewModel.eventDetail {
            isInitialDataLoaded = true
            
            title = eventDetail.title
            placeText = eventDetail.eventWhereText ?? ""
            place = eventDetail.eventWherePlace
            content = eventDetail.what
            people = eventDetail.withWho
            categorySelectViewModel.selectedCategory = eventDetail.categories
            
            for url in eventDetail.eventImageUrlList {
                urlToUIImage(url: url) { image in
                    if let image = image {
                        DispatchQueue.main.async {
                            imageViewModelForPut.uiImageList.append(image)
                        }
                    } else {
                        print("이벤트 수정 : 이미지 불러오기 실패")
                    }
                }
            }
        }
    }
    
    func updateEvent() {
        Task {
            var imagesData: [Data] = []
            
            for image in imageViewModelForPut.uiImageList {
                imagesData.append(image.downscaleTOjpegData(maxBytes: 400_000))
            }
            
            for image in imagePickerForEventViewModel.selection {
                if let imageData = try? await image.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: imageData) {
                        imagesData.append(image.downscaleTOjpegData(maxBytes: 400_000))
                    } else {
                        print("❌ EventEditView : UIImage 변환 실패")
                    }
                } else {
                    print("❌ EventEditView : Failed to load image data")
                }
            }
            
            let placeTextOrNil: String?
            if placeText == "" {
                placeTextOrNil = nil
            } else {
                placeTextOrNil = placeText
            }
            
            eventViewModel.updateEvent(
                eventId: eventViewModel.eventDetail!.eventId,
                eventTitle: title,
                eventWhat: content,
                eventWhereText: placeTextOrNil,
                eventWherePlace: place,
                withWho: people,
                year: eventViewModel.eventDetail!.EventYear,
                month: eventViewModel.eventDetail!.EventMonth,
                date: eventViewModel.eventDetail!.EventDate,
                categoryIds: categorySelectViewModel.getSelectedCategoryIds(),
                images: imagesData
            )
        }
    }
}
