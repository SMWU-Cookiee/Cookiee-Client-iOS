//
//  ProfileEditView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/24/24.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @State var nickname: String = ""
    @State var introduction: String = ""
    
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var newImage: UIImage?
    @State var imageURL: String?

    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        newImage = selectedImage
    }
    
    @State var submitButtonColor: Color = .Gray02
    
    var body: some View {
        VStack {
            HStack {
                if let imageURL = profileViewModel.profile.profileImage {
                    AsyncImage(url: URL(string: imageURL)) { result in
                        result.image?
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 129, height: 129)
                    }
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
        
            HStack() {
                Text("닉네임")
                    .font(.Body0_SB)
                    .frame(width: 75, alignment: .leading)
                TextField("\(nickname)", text: $nickname)
                    .placeholder(when: nickname.isEmpty) {
                        Text("\(profileViewModel.profile.nickname)")
                            .foregroundStyle(Color.Gray04)
                            .font(.Body0_M)
                }
                    .padding(10)
                    .font(.Body1_M)
                    .frame(height: 40)
                    .background(Color.Gray01)
                    .cornerRadius(5)
                    .onChange(of: nickname) {
                        if nickname != profileViewModel.profile.nickname {
                            submitButtonColor = .Brown01
                        } else {
                            submitButtonColor = .Gray02
                        }
                    }
            }
            .padding(.bottom, 5)
            
            HStack {
                Text("한 줄 소개")
                    .font(.Body0_SB)
                    .frame(width: 75, alignment: .leading)
                TextField("\(introduction)", text: $introduction)
                    .placeholder(when: introduction.isEmpty) {
                        Text("\(profileViewModel.profile.selfDescription)")
                            .foregroundStyle(Color.Gray04)
                            .font(.Body0_M)
                }
                    .padding(10)
                    .font(.Body1_M)
                    .frame(height: 40)
                    .background(Color.Gray01)
                    .cornerRadius(5)
                    .onChange(of: introduction) {
                        if introduction != profileViewModel.profile.selfDescription {
                            submitButtonColor = .Brown01
                        } else {
                            submitButtonColor = .Gray02
                        }
                    }
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
        .navigationBarItems(trailing: Button(action: {
            profileViewModel.updateUserProfile(nickname: nickname, selfDescription: introduction, newUIImage: newImage)
        }, label: {
            Text("완료")
                .font(.Body0_B)
                .foregroundColor(submitButtonColor)
        }))

        .padding()
        .padding(.top, 10)
        .onAppear() {
            profileViewModel.loadUserProfile()
        }
        .onChange(of: profileViewModel.isSuccess) {
            if profileViewModel.isSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    ProfileEditView()
}
