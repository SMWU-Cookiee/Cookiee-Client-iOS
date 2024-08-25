//
//  CategoryAddView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/25/24.
//

import SwiftUI

import SwiftUI

struct CategoryAddAndEditView: View {
    @State var isNewCategory: Bool = true
    
    @State var id: String = ""
    @State var name: String = ""
    @State var selectedColor: String = ""
    
    @State private var isShowColorPicker: Bool = false
    @State var toggleIsOpenCategoryAddSheet: () -> Void

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        toggleIsOpenCategoryAddSheet()
                    }, label: {
                        Image("XmarkIcon")
                    })
                    
                    Spacer()
                    Text(isNewCategory ? "카테고리 추가하기" : "카테고리 수정하기")
                        .font(.Head1_B)
                    Spacer()
                    Button(action: {
                        // Save action
                    }, label: {
                        Text("완료")
                            .font(.Body0_B)
                            .foregroundStyle(Color.Gray03)
                    })
                }
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
                        .padding(10)
                        .font(.Body0_M)
                        .foregroundStyle(Color.Gray04)
                        .frame(height: 40)
                        .background(Color.Gray01)
                        .cornerRadius(5)
                }
                .padding(.bottom, 10)
                
                HStack {
                    Text("카테고리 색")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 92, alignment: .leading)
                    Button(action: {
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
                }
                
                Spacer()
            }
            .padding()
            
            if isShowColorPicker {
                ColorPickerBottomSheetView(isPresented: $isShowColorPicker, selectedColor: $selectedColor)
                    .transition(.move(edge: .bottom))
                    .shadow(color: .black.opacity(0.05), radius: 13, x: 0, y: -5)
            }
        }
        .padding(.top, 20)
    }
}

struct ColorPickerBottomSheetView: View {
    @Binding var isPresented: Bool
    @Binding var selectedColor: String
    
    var body: some View {
        VStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            ZStack {
                UIColorPickerViewControllerWrapper(selectedColor: $selectedColor) {
                    withAnimation {
                        isPresented = false
                    }
                }
                .frame(height: 520)
            }
            .background(Color.white)
            .zIndex(1)
        }
    }
}
