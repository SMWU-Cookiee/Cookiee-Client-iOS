//
//  ProfileEditView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/24/24.
//

import SwiftUI

struct ProfileEditView: View {
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
    
    @State var nickname: String = "nickname_sample"
    @State var introduction: String = "introduction_sample"
    
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        VStack {
            // 프로필 이미지
            HStack {
                if let image = image {
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 129, height: 129)
                } else {
                    Circle()
                        .foregroundColor(Color.Gray01)
                        .frame(width: 129, height: 129)
                        .overlay(
                            Button(action: {
                                showImagePicker.toggle()
                            }, label: {
                                Image("Photo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            })
                            
                        )
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                loadImage()
            }) {
                ImagePicker(image: $selectedUIImage)
            }
            .padding(.bottom, 35)
        
            // 닉네임 편집
            HStack() {
                Text("닉네임")
                    .font(.Body0_SB)
                    .frame(width: 75, alignment: .leading)
                TextField("\(nickname)", text: $nickname)
                    .padding(10)
                    .font(.Body1_M)
                    .frame(height: 40)
                    .background(Color.Gray01)
                    .cornerRadius(5)
            }
            .padding(.bottom, 5)
            
            // 한 줄 소개 편집
            HStack {
                Text("한 줄 소개")
                    .font(.Body0_SB)
                    .frame(width: 75, alignment: .leading)
                TextField("\(introduction)", text: $introduction)
                    .padding(10)
                    .font(.Body1_M)
                    .frame(height: 40)
                    .background(Color.Gray01)
                    .cornerRadius(5)
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("프로필 수정")
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

#Preview {
    ProfileEditView()
}
