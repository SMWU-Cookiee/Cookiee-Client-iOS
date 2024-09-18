//
//  CategoryEditView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/21/24.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = CategoryListViewModel()
    @State var isModalOpen: Bool = false
    @State private var isAddButtonTapped = false

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
            ScrollView {
                ForEach(viewModel.categoryListData?.result ?? []) { category in
                    CategoryListRowView(name: category.name, color: category.color)
                }
                CategoryAddButtonView(toggleIsTapped: {
                    isAddButtonTapped.toggle()
                })
            }
            
        }
        .sheet(isPresented: $isAddButtonTapped) {
            CategoryAddAndEditView(toggleIsOpenCategoryAddSheet: {
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
            viewModel.loadCategoryListData()
        }
    }
}

#Preview {
    CategoryListView()
}

struct CategoryListRowView: View {
    @State var id: String = ""
    @State var name: String = ""
    @State var color: String
    
    @State private var isEditButtonTapped = false
    
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
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("TrashIconRed")
                })
            }
            Divider()
        }
        .sheet(isPresented: $isEditButtonTapped) {
            CategoryAddAndEditView(
                isNewCategory: false,
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

struct CategoryAddButtonView: View {
    @State var name: String = ""
    @State var toggleIsTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                // 색상
                Rectangle()
                    .fill(Color.Gray02)
                    .frame(width: 25, height: 25)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    .overlay(Image("Plus"))
                
                // 이름
                HStack {
                    Button(action: {
                        toggleIsTapped()
                    }, label: {
                        Text("추가하기")
                            .font(.Body1_M)
                            .foregroundColor(.black)
                    })
                    
                }
                .font(.Body1_M)
                .frame(height: 35)
                
                Spacer()
            }
        }
    }
}
