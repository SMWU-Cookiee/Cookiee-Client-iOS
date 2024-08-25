//
//  CategoryAddView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/25/24.
//

import SwiftUI

struct CategoryAddView: View {
    @State private var name: String = ""
    @State private var selectedColor: String = ""
    @State private var isShowColorPicker: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    //
                }, label: {
                    Image("XmarkIcon")
                })
                
                Spacer()
                Text("카테고리 추가하기")
                    .font(.Head1_B)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
                    isShowColorPicker.toggle()
                }, label: {
                    if selectedColor == "" {
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
                    .sheet(isPresented: $isShowColorPicker) {
                        UIColorPickerViewControllerWrapper(selectedColor: $selectedColor) {
                            isShowColorPicker = false
                        }
                        .presentationDetents([.fraction(0.70)])
                    }
                
            }
            
            Spacer()
        }
        .padding()
        .padding(.top, 20)
    }
}

#Preview {
    CategoryAddView()
}
