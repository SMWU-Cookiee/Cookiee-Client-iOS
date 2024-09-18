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
    
    @State var title: String = "쿠키의 제목을 입력해주세요."
    @State var place: String = "장소를 입력해주세요."
    @State var content: String = "어떤 활동을 하셨나요?"
    @State var people: String = "함께한 사람들을 입력해주세요."
    
    
   
    var body: some View {
        VStack {
            VStack {
                EventInfoTextField(fieldName: "쿠키 제목", field: title)
                EventInfoTextField(fieldName: "장소", field: place)
                EventInfoTextField(fieldName: "내용", field: content)
                EventInfoTextField(fieldName: "함께한 사람", field: people)
                
                VStack(alignment: .leading) {
                    Text("카테고리")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    Button(action: {
                        
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
            Spacer()
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

        .padding()
        .padding(.top, 10)
    }
}

struct EventInfoTextField : View {
    
    var fieldName: String
    @State var field: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .font(.Body1_M)
                .foregroundStyle(Color.Gray05)
                .frame(width: 75, alignment: .leading)
            TextField("\(field)", text: $field)
                .padding(10)
                .font(.Body0_M)
                .frame(height: 40)
                .background(Color.Gray01)
                .foregroundStyle(Color.Gray04)
                .cornerRadius(5)
        }
        .padding(.bottom, 25)
    }
}

#Preview {
    EventAddView()
}
