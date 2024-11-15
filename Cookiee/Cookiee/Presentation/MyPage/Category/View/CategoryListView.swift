//
//  CategoryEditView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/21/24.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var stateCategoryListViewModel = CategoryListViewModel()

    @State private var isAddButtonTapped = false
    @State private var isDeleteButtonTapped = false
    @State private var categoryNameToDelete: String?
    @State private var categoryIdToDelete: String?
    

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
    
    var body: some View {
        VStack {
            if !stateCategoryListViewModel.isLoadingCompleted {
                ProgressView()
            } else {
                ScrollView {
                    ForEach(stateCategoryListViewModel.categories, id:\.id) { category in
                        CategoryListRowView(
                            id: category.categoryId.description,
                            name: category.categoryName,
                            color: category.categoryColor,
                            isDeleteButtonTapped: $isDeleteButtonTapped,
                            categoryNameToDelete: $categoryNameToDelete,
                            categoryIdToDelete: $categoryIdToDelete,
                            categoryListViewModel: stateCategoryListViewModel
                        )
                    }
                    CategoryAddButtonView(toggleIsTapped: {
                        isAddButtonTapped.toggle()
                    })
                }
            }
        }
        .sheet(isPresented: $isAddButtonTapped, onDismiss: {
            print("카테고리 추가 onDismiss")
            stateCategoryListViewModel.loadCategoryListData()
        }) {
            CategoryAddAndEditView(categoryListViewModel: stateCategoryListViewModel, toggleIsOpenCategoryAddSheet: {
                isAddButtonTapped.toggle()
            })
            .presentationDetents([.fraction(0.95)])
            .presentationDragIndicator(Visibility.visible)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("카테고리 관리")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding()
        .padding(.top, 10)
        .onAppear {
            DispatchQueue.main.async {
                print("🔥 카테고리-리스트-뷰 onAppear")
                stateCategoryListViewModel.loadCategoryListData()
           }
        }
//        .onChange(of: stateCategoryListViewModel.isUpdateSuccess) {
//            presentationMode.wrappedValue.dismiss()
//        }
        .showCustomAlert(
            isPresented: $isDeleteButtonTapped,
            content: {
                AnyView(
                    VStack {
                        Text(categoryNameToDelete!)
                            .font(.Head1_B)
                            .foregroundStyle(Color.Brown01)
                        Text("카테고리를 삭제할까요?")
                            .font(.Head1_B)
                            .padding(.bottom, 9)
                        Text("삭제하면 복구가 어렵습니다.")
                            .font(.Body1_R)
                    }
                )
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
                        stateCategoryListViewModel.removeCategory(categoryId: categoryIdToDelete!)
                    },
                    title: Text("삭제하기").foregroundColor(Color.Brown00))
        )
    }
    
    
}

#Preview {
    CategoryListView()
}

