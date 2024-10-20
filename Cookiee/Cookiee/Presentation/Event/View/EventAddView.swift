//
//  EventAddView.swift
//  Cookiee
//
//  Created by minseo Kyung on 9/18/24.
//

import SwiftUI

struct EventAddView: View {
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
    
    @State var title: String = ""
    @State var place: String = ""
    @State var content: String = ""
    @State var people: String = ""
    
    @State var isCategorySelectButtonTapped: Bool = true
    
    
   
    var body: some View {
        ScrollView {
            InitialAddMessageCardView()
                .padding(.bottom, 14)
            
            VStack {
                EventInfoTextField(fieldName: "쿠키 제목", placeholder: "쿠키의 제목을 입력해주세요.", field: title)
                EventInfoTextField(fieldName: "장소", placeholder: "장소를 입력해주세요.", field: place)
                EventInfoTextField(fieldName: "내용", placeholder: "어떤 활동을 하셨나요?", field: content)
                EventInfoTextField(fieldName: "함께한 사람", placeholder: "함께한 사람들을 입력해주세요.", field: people)
            }
            
            VStack(alignment: .leading) {
                Text("카테고리")
                    .font(.Body1_M)
                    .foregroundStyle(Color.Gray05)
                    .frame(width: 75, alignment: .leading)
                Button(action: {
                    isCategorySelectButtonTapped = true
                }) {
                    HStack {
                        Text("카테고리를 선택해주세요.")
                            .font(.Body0_M)
                            .foregroundStyle(Color.Black)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("쿠키 추가하기")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarItems(trailing: Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text("완료")
                .font(.Body0_B)
                .foregroundColor(.Gray03)
        }))
        
        .sheet(isPresented: $isCategorySelectButtonTapped, onDismiss: {
          
        }) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 18) {
                    Text("내 카테고리")
                        .font(.Head1_B)
                        .padding(.top, 25)
                    
                    VStack {
                        CategorySelectButtonView(name: "카테고리", color: "#363636")
                        CategorySelectButtonView(name: "카테고리2", color: "#367777")
                    }
                    
                    Spacer()
                    
                }
                
                VStack {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Text("카테고리 추가하기")
                                .font(.Body0_SB)
                                .foregroundStyle(Color.Gray00)
                        }
                        
                    })
                    .frame(width: 363, height: 44)
                    .background(Color.Gray03)
                    .cornerRadius(10)
                }
                .padding(10)
                .frame(height: 67)
                .background(Color.White)
                .shadow(color: .black.opacity(0.05), radius: 13, x: 0, y: -10)
            }
            .presentationDetents([.fraction(0.60)])
            .presentationDragIndicator(Visibility.visible)
        }

        .padding()
        .padding(.top, 10)
    }
}

struct EventInfoTextField : View {
    
    var fieldName: String
    var placeholder: String
    @State var field: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .font(.Body1_M)
                .foregroundStyle(Color.Gray05)
                .frame(width: 75, alignment: .leading)
            
            TextField("", text: $field)
                .placeholder(when: field.isEmpty) {
                    Text(placeholder)
                        .foregroundStyle(Color.Gray04)
                        .font(.Body0_M)
            }
            .padding(10)
            .frame(height: 40)
            .background(Color.Gray01)
            .cornerRadius(5)
        }
        .padding(.bottom, 25)
    }
}

struct InitialAddMessageCardView: View {
    var body: some View {
        HStack {
            Button(action: {}, label: {
                VStack {
                    Image("Photo")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(10)
                    
                    Text("최대 5장까지 추가할 수 있어요.")
                        .foregroundStyle(Color.Gray04)
                        .font(Font.Body1_M)
                }
            })
        }
        .frame(width: 270, height: 360)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Gray04, lineWidth: 1)
        )
    }
}

struct CategorySelectButtonView : View {
    var name: String
    var color: String
    
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color(hex: color))
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .padding(.leading, 15)
            
            Text(name)
                .font(.Body1_R)
            
            Spacer()
        }
        .frame(width: 348, height: 47)
        .background(Color.Gray00)
        .cornerRadius(8.0)

    }
}

#Preview {
    EventAddView()
}
