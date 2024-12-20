//
//  CategoryEditView.swift
//  Cookiee
//
//  Created by minseo Kyung on 11/24/24.
//

import SwiftUI

struct CategoryEditView: View {
    @ObservedObject var categoryListViewModel: CategoryListViewModel
    @ObservedObject var categoryViewModel = CategoryViewModel()
    
    @State var id: String = ""
    @State var name: String = ""
    @State var selectedColor: String = ""
    
    @State private var isShowColorPicker: Bool = false
    @State var toggleIsOpenCategoryAddSheet: () -> Void
    
    @State private var isSubmitButtonDisabled: Bool = true
    @State private var submitButtonColor: Color = .Gray03
    @FocusState private var isTextFieldFocused: Bool

    func isValidForm() {
            let hasChanges = name != categoryViewModel.category?.categoryName || selectedColor != categoryViewModel.category?.categoryColor
            submitButtonColor = hasChanges ? .Brown01 : .Gray03
            isSubmitButtonDisabled = !hasChanges
        }

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            toggleIsOpenCategoryAddSheet()
                        }, label: {
                            Image("XmarkIcon")
                        })
                        .frame(alignment: .leading)
                        
                        Spacer()
                        
                        Button(action: {
                            categoryListViewModel.updateCategory(categoryId: id, categoryName: name, categoryColor: selectedColor)
                            toggleIsOpenCategoryAddSheet()
                        }, label: {
                            Text("완료")
                                .font(.Body0_B)
                                .foregroundStyle(submitButtonColor)
                        })
                        .padding(.trailing, 10)
                        .disabled(isSubmitButtonDisabled)
                    }
                    
                    Spacer()
                    Text("카테고리 수정하기")
                        .font(.Head1_B)
                        .frame(alignment: .center)

                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 25)
                
                HStack {
                    Text("카테고리 이름")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 92, alignment: .leading)
                    TextField(
                        "카테고리 이름",
                        text: $name,
                        prompt: Text("카테고리 이름을 입력해주세요.").foregroundColor(Color.Gray04)
                    )
                        .focused($isTextFieldFocused)
                        .padding(10)
                        .font(.Body0_M)
                        .frame(height: 40)
                        .background(Color.Gray01)
                        .cornerRadius(5)
                        .onChange(of: name) {
                            isValidForm()
                        }
                }
                .padding(.bottom, 10)
                .frame(width: 353)
                
                HStack {
                    Text("카테고리 색")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 92, alignment: .leading)
                    Button(action: {
                        isTextFieldFocused = false
                        withAnimation(.easeInOut) {
                            isShowColorPicker.toggle()
                        }
                    }, label: {
                        if selectedColor.isEmpty {
                            Text("탭하여 색 선택하기")
                                .foregroundStyle(Color.Gray04)
                        } else {
                            Rectangle()
                                .fill(Color(hex: selectedColor))
                                .frame(width: 25, height: 25)
                                .cornerRadius(3.0)
                        }
                        
                        Spacer()
                        Image("ChevronRightSmall")
                    })
                        .padding(10)
                        .font(.Body0_M)
                        .frame(height: 40)
                        .background(Color.Gray01)
                        .cornerRadius(5)
                        .onChange(of: selectedColor) {
                            isValidForm()
                        }
                }
                .frame(width: 353)
                
                Spacer()
            }
            .padding(10)
            
            if isShowColorPicker {
                ColorPickerBottomSheetView(isPresented: $isShowColorPicker, selectedColor: $selectedColor)
                    .transition(.move(edge: .bottom))
                    .shadow(color: .black.opacity(0.05), radius: 13, x: 0, y: -5)
            }
        }
        .padding(.top, 20)
        .onAppear {
            categoryViewModel.category = CategoryData(categoryName: name, categoryColor: selectedColor)
            isValidForm()
        }
    }
}
