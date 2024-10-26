//
//  EventUpdateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import SwiftUI
import PhotosUI

struct EventEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // 백 버튼 커스텀
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
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
    
    var isValidForm: Bool {
        !title.isEmpty && !place.isEmpty && !content.isEmpty && !people.isEmpty && !categorySelectViewModel.selectedCategory.isEmpty && !imagePickerForEventViewModel.selection.isEmpty
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                if (imagePickerForEventViewModel.selection.isEmpty) {
                    InitialAddMessageCardView(viewModel: imagePickerForEventViewModel)
                } else {
                    ImageCarouselForUIImageView(viewModel: imagePickerForEventViewModel)
                }
            }
            .padding(.bottom, 14)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("쿠키 제목")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    
                    CustomTextField(target: $title, placeholder: "쿠키의 제목을 입력해주세요.")
                }
                .padding(.bottom, 25)
                VStack(alignment: .leading) {
                    Text("장소")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    
                    CustomTextField(target: $place, placeholder: "장소를 입력해주세요.")
                }
                .padding(.bottom, 25)
                VStack(alignment: .leading) {
                    Text("내용")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    
                    CustomTextField(target: $content, placeholder: "어떤 활동을 하셨나요?")
                }
                .padding(.bottom, 25)
                VStack(alignment: .leading) {
                    Text("함께한 사람")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    
                    CustomTextField(target: $people, placeholder: "함께한 사람들을 입력해주세요.")
                }
                .padding(.bottom, 25)
                
                VStack(alignment: .leading) {
                    Text("카테고리")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    Button(action: {
                        isCategorySelectButtonTapped = true
                    }) {
                        HStack {
                            if (categorySelectViewModel.selectedCategory.isEmpty) {
                                Text("카테고리를 선택해주세요.")
                                    .font(.Body0_M)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("쿠키 수정하기")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarItems(trailing: Button(action: {
            if isValidForm {
                eventViewModel.addEvent(
                    eventTitle: title,
                    eventWhat: content,
                    eventWhere: place,
                    withWho: people,
                    year: year,
                    month: month,
                    date: date,
                    categoryIds: categorySelectViewModel.getSelectedCategoryIds(),
                    images: imagePickerForEventViewModel.selection)
            }
        }, label: {
            Text("완료")
                .font(.Body0_B)
                .foregroundColor(isValidForm ? .Brown01 : .Gray03)
        }))
        
        .sheet(isPresented: $isCategorySelectButtonTapped) {
            VStack {
                VStack(spacing: 18) {
                    Text("내 카테고리")
                        .font(.Head1_B)
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
                            .font(.Body0_SB)
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
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
