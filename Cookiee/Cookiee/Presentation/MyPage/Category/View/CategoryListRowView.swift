//
//  CategoryListRowView.swift
//  Cookiee
//
//  Created by minseo Kyung on 11/16/24.
//

import SwiftUI

struct CategoryListRowView: View {
    @State var id: String = ""
    @State var name: String = ""
    @State var color: String
    @State var isEditButtonTapped: Bool = false
    
    @Binding var isDeleteButtonTapped: Bool
    @Binding var categoryNameToDelete: String?
    @Binding var categoryIdToDelete: String?
    
    @ObservedObject var categoryListViewModel : CategoryListViewModel
    
    var body: some View {
        VStack {
            HStack {
                // 색상
                Rectangle()
                    .fill(Color(hex: color))
                    .frame(width: 25, height: 25)
                    .cornerRadius(3.0)
                
                // 이름
                HStack {
                    Text(name)
                    Spacer()
                    // 수정 버튼
                    Button(action: {
                        isEditButtonTapped = true
                    }, label: {
                        Image("EditIconBrown")
                    })
                }
                .padding(10)
                .font(.Body1_M)
                .frame(height: 35)
                .background(Color.Gray01)
                .cornerRadius(3.0)
                            
                // 삭제 버튼
                Button(action: {
                    DispatchQueue.main.async {
                        categoryNameToDelete = name
                        categoryIdToDelete = id
                        isDeleteButtonTapped = true
                    }
                }, label: {
                    Image("TrashIconRed")
                })
            }
            Divider()
        }
        .sheet(isPresented: $isEditButtonTapped, onDismiss: {
            print("카테고리 수정 onDismiss")
            categoryListViewModel.loadCategoryListData()
            
        }) {
            CategoryEditView(
                categoryListViewModel: categoryListViewModel,
                id: id,
                name: name,
                selectedColor: color,
                toggleIsOpenCategoryAddSheet: {
                    isEditButtonTapped.toggle()
            })
                .presentationDetents([.fraction(0.95)])
                .presentationDragIndicator(Visibility.visible)
        }
    }
}

