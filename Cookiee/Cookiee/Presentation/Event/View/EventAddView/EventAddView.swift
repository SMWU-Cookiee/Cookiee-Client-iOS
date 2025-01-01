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
    @State var place: String = ""
    @State var content: String = ""
    @State var people: String = ""
    
    @State var isCategorySelectButtonTapped: Bool = false
    
    @ObservedObject var eventViewModel = EventViewModel()
    @ObservedObject var categoryListViewModel = CategoryListViewModel()
    @ObservedObject var categorySelectViewModel = CategorySelectViewModel()
    @StateObject var imagePickerForEventViewModel = ImagePickerForEventViewModel()
    
    @State var maxImageCount: Int = 5
    @State var isSubmitting: Bool = false
    
    @FocusState private var isFocused: Bool
    
    
    var isValidForm: Bool {
        !title.isEmpty && !place.isEmpty && !content.isEmpty && !people.isEmpty && !categorySelectViewModel.selectedCategory.isEmpty && !imagePickerForEventViewModel.selection.isEmpty
    }
    
    var body: some View {
        ZStack {
            ScrollView (.vertical, showsIndicators: true) {
                VStack {
                    if (imagePickerForEventViewModel.selection.isEmpty) {
                        InitialAddMessageCardView(viewModel: imagePickerForEventViewModel)
                    } else {
                        ImageCarouselForPhotoPicker(viewModel: imagePickerForEventViewModel)
                    }
                }
                .padding(.bottom, 14)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("쿠키 제목")
                            .font(Font.Body1_M)
                            .foregroundStyle(Color.Gray05)
                            .frame(width: 75, alignment: .leading)
                        
                        CustomTextField(target: $title, placeholder: "쿠키의 제목을 입력해주세요.")
                            .focused($isFocused)
                    }
                    .padding(.bottom, 25)
                    VStack(alignment: .leading) {
                        Text("장소")
                            .font(Font.Body1_M)
                            .foregroundStyle(Color.Gray05)
                            .frame(width: 75, alignment: .leading)
                        
                        CustomTextField(target: $place, placeholder: "장소를 입력해주세요.")
                            .focused($isFocused)
                    }
                    .padding(.bottom, 25)
                    VStack(alignment: .leading) {
                        Text("내용")
                            .font(Font.Body1_M)
                            .foregroundStyle(Color.Gray05)
                            .frame(width: 75, alignment: .leading)
                        
                        CustomTextFieldMultiLine(target: $content, placeholder: "어떤 활동을 하셨나요?")
                            .focused($isFocused)
                    }
                    .padding(.bottom, 25)
                    VStack(alignment: .leading) {
                        Text("함께한 사람")
                            .font(Font.Body1_M)
                            .foregroundStyle(Color.Gray05)
                            .frame(width: 75, alignment: .leading)
                        
                        CustomTextField(target: $people, placeholder: "함께한 사람들을 입력해주세요.")
                            .focused($isFocused)
                    }
                    .padding(.bottom, 25)
                    
                    VStack(alignment: .leading) {
                        Text("카테고리")
                            .font(Font.Body1_M)
                            .foregroundStyle(Color.Gray05)
                            .frame(width: 75, alignment: .leading)
                        Button(action: {
                            isCategorySelectButtonTapped = true
                        }) {
                            HStack {
                                if (categorySelectViewModel.selectedCategory.isEmpty) {
                                    Text("카테고리를 선택해주세요.")
                                        .font(Font.Body0_M)
                                        .foregroundStyle(Color.Black)
                                } else {
                                    ForEach(categorySelectViewModel.selectedCategory, id: \.categoryId) { category in
                                        CategoryLabelViewDeletable(
                                            name: category.categoryName,
                                            color: category.categoryColor,
                                            action: {
                                                categorySelectViewModel.removeCategoryFromEvent(id: category.categoryId)
                                            }
                                        )
                                        .padding(.horizontal, 1)
                                    }
                                }
                                Spacer()
                                Image("UnderDropBlack")
                                    .padding(2)
                            }
                            .padding(10)
                            .frame(height: 40)
                            .background(Color.Gray01)
                            .cornerRadius(5)
                        }
                    }
                    .padding(.bottom, 25)
                }
                .padding()
            }
 
            if isSubmitting {
                VStack {
                    Spacer()
                    ProgressView()
                        .controlSize(.large)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
                
            }
        }
        .padding(.top, 10)
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
                        eventViewModel.addEvent(
                            eventTitle: title,
                            eventWhat: content,
                            eventWhere: place,
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
        
        .sheet(isPresented: $isCategorySelectButtonTapped) {
            VStack {
                VStack(spacing: 18) {
                    Text("내 카테고리")
                        .font(Font.Head1_B)
                        .padding(.top, 25)
                    
                    ScrollView {
                        ForEach(categoryListViewModel.categories, id:\.id) { category in
                            CategorySelectButtonView(
                                id: category.categoryId,
                                name: category.categoryName,
                                color: category.categoryColor,
                                viewModel: categorySelectViewModel
                            )
                        }
                    }
                }
                
                VStack {
                    Button(action: {
                        isCategorySelectButtonTapped = false
                    }, label: {
                        Text("카테고리 추가하기")
                            .font(Font.Body0_SB)
                            .foregroundStyle(Color.Gray00)
                    })
                    .frame(width: 363, height: 44)
                    .background(categorySelectViewModel.selectedCategory.isEmpty ? Color.Gray03 : Color.Brown00)
                    .cornerRadius(10)
                }
                .padding(10)
                .frame(height: 67)
                .background(Color.White)
                .shadow(color: .black.opacity(0.05), radius: 13, x: 0, y: -10)
            }
            .onAppear() {
                categoryListViewModel.loadCategoryListData()
            }
            .presentationDetents([.fraction(0.60)])
            .presentationDragIndicator(Visibility.visible)
        }
        
        .showCustomAlert(
            isPresented: $isBackButtonTapped,
            content: {
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
}
