//
//  EventAddView.swift
//  Cookiee
//
//  Created by minseo Kyung on 9/18/24.
//

import SwiftUI
import PhotosUI

struct EventAddView: View {
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
    
    var year: Int32
    var month: Int32
    var date: Int32
    
    @State var title: String = ""
    @State var content: String = ""
    @State var people: String = ""
    @State var placeText: String = ""
    @State var place: EventWherePlace? = nil
    
    @State var isCategorySelectButtonTapped: Bool = false
    
    @ObservedObject var eventViewModel = EventViewModel()
    @ObservedObject var categoryListViewModel = CategoryListViewModel()
    @ObservedObject var categorySelectViewModel = CategorySelectViewModel()
    @StateObject var imagePickerForEventViewModel = ImagePickerForEventViewModel()
    @ObservedObject var locationSearchService = EventMapLocationSearchViewModel()
    
    @State var maxImageCount: Int = 5
    @State var isSubmitting: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var isValidForm: Bool {
        !title.isEmpty &&
        !content.isEmpty &&
        !people.isEmpty &&
        !categorySelectViewModel.selectedCategory.isEmpty &&
        !imagePickerForEventViewModel.selection.isEmpty &&
        (!placeText.isEmpty || place != nil)
    }
    
    var body: some View {
        ZStack {
            contentScrollView
                .padding(.top, 10)
            submittingOverlay
        }
        .photosPicker(
            isPresented: $imagePickerForEventViewModel.isPhotoPickerPresented,
            selection: $imagePickerForEventViewModel.selection,
            maxSelectionCount: maxImageCount,
            selectionBehavior: .continuousAndOrdered,
            matching: .images,
            preferredItemEncoding: .current,
            photoLibrary: .shared()
        )
        .photosPickerStyle(.presentation)
        
        .onChange(of: eventViewModel.isAddSuccess) {
            if eventViewModel.isAddSuccess {
                eventViewModel.isAddSuccess = false
                isSubmitting = false
                presentationMode.wrappedValue.dismiss()
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
        
        .showCustomAlert(
            isPresented: $isBackButtonTapped,
            alertContent: {
                VStack(alignment: .center) {
                        Text("쿠키 추가를 그만할까요?")
                            .font(Font.Head1_B)
                            .padding(.bottom, 9)
                        Text("페이지를 나가면 복구가 어렵습니다.")
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
                if (imagePickerForEventViewModel.selection.isEmpty) {
                    InitialAddMessageCardView(viewModel: imagePickerForEventViewModel)
                } else {
                    ImageCarouselForPhotoPicker(viewModel: imagePickerForEventViewModel)
                }
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
                VStack {
                    progressIndicator
                }
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
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
    
    private var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                Text("쿠키 추가하기")
                    .font(Font.Head1_B)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isValidForm {
                        isSubmitting = true
                        
                        let placeTextOrNil: String?
                        if placeText == "" {
                            placeTextOrNil = nil
                        } else {
                            placeTextOrNil = placeText
                        }
                        
                        eventViewModel.addEvent(
                            eventTitle: title,
                            eventWhat: content,
                            eventWhereText: placeTextOrNil,
                            eventWherePlace: place,
                            withWho: people,
                            year: year,
                            month: month,
                            date: date,
                            categoryIds: categorySelectViewModel.getSelectedCategoryIds(),
                            images: imagePickerForEventViewModel.selection
                        )
                    }
                }, label: {
                    Text("완료")
                        .font(Font.Body0_B)
                        .foregroundColor(isValidForm && !isSubmitting ? Color.Brown01 : Color.Gray03)
                })
                .disabled(!isValidForm || isSubmitting)
            }
        }
    }
}
