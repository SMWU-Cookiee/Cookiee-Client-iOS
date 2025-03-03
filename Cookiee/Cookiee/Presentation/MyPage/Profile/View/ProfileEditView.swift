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
    @State var imageURL: String?
    @State var newImage: UIImage?
    
    @State var submitButtonColor: Color = .Gray02
    @State var isSubmitButtonDisabled: Bool = true

    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        profileViewModel.newSelectedImage = selectedImage
    }
    
    func isValidForm() {
        let nicknameChanged = !nickname.trimmingCharacters(in: .whitespaces).isEmpty && nickname != profileViewModel.profile.nickname
        let introductionChanged = !introduction.trimmingCharacters(in: .whitespaces).isEmpty && introduction != profileViewModel.profile.selfDescription
        let imageChanged = profileViewModel.newSelectedImage != nil

        let hasChanges = nicknameChanged || introductionChanged || imageChanged

        submitButtonColor = hasChanges ? .Brown01 : .Gray02
        isSubmitButtonDisabled = !hasChanges
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        showImagePicker.toggle()
                    }, label: {
                        if let imageURL = profileViewModel.profile.profileImage {
                            if (newImage != nil) {
                                Image(uiImage: newImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 129, height: 129)
                                    .clipShape(Circle())
                                
                            } else {
                                AsyncImage(url: URL(string: imageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        Circle()
                                            .fill(Color.Gray01)
                                            .frame(width: 129, height: 129)
                                            .overlay(ProgressView())
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 129, height: 129)
                                            .clipShape(Circle())
                                        
                                    case .failure(_):
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .frame(width: 129, height: 129)
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundStyle(Color.gray)
                                            )
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        } else {
                            Circle()
                                .foregroundColor(Color.Gray01)
                                .frame(width: 129, height: 129)
                                .overlay(
                                    VStack {
                                        Image("Photo")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                )
                        }
                    })
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    loadImage()
                    isValidForm()
                }) {
                    ImagePicker(image: $selectedUIImage)
                }
                .padding(.bottom, 35)
            
                HStack() {
                    Text("닉네임")
                        .font(.Body0_SB)
                        .frame(width: 75, alignment: .leading)
                        .foregroundStyle(Color.Brown00)
                    TextField("\(nickname)", text: $nickname)
                        .placeholder(when: nickname.isEmpty) {
                            Text("\(profileViewModel.profile.nickname)")
                                .foregroundStyle(Color.Brown00)
                                .font(.Body0_M)
                    }
                        .padding(10)
                        .font(.Body0_M)
                        .frame(height: 40)
                        .background(Color.white)
                        .cornerRadius(5)
                        .onChange(of: nickname) {
                            isValidForm()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                               .stroke(Color.Brown02, lineWidth: 1)
                        )
                }
                .padding(.bottom, 5)
                
                HStack {
                    Text("한 줄 소개")
                        .font(.Body0_SB)
                        .frame(width: 75, alignment: .leading)
                        .foregroundStyle(Color.Brown00)
                    TextField("\(introduction)", text: $introduction)
                        .placeholder(when: introduction.isEmpty) {
                            Text("\(profileViewModel.profile.selfDescription)")
                                .foregroundStyle(Color.Brown00)
                                .font(.Body0_M)
                    }
                        .padding(10)
                        .font(.Body0_M)
                        .frame(height: 40)
                        .background(Color.white)
                        .cornerRadius(5)
                        .onChange(of: introduction) {
                            isValidForm()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                               .stroke(Color.Brown02, lineWidth: 1)
                        )
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
                profileViewModel.updateUserProfile(nickname: nickname, selfDescription: introduction, newUIImage: profileViewModel.newSelectedImage)
            }, label: {
                Text("완료")
                    .font(.Body0_B)
                    .foregroundColor(submitButtonColor)
            })
            .disabled(isSubmitButtonDisabled))
            .padding()
            .padding(.top, 10)
            .onAppear {
                profileViewModel.loadUserProfile()
            }
            .onChange(of: profileViewModel.isSuccess) {
                if profileViewModel.isSuccess {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onChange(of: profileViewModel.newSelectedImage) {
                newImage = profileViewModel.newSelectedImage
                isValidForm()
            }
            
            if profileViewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .controlSize(.large)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
            }
        }
    }
}

#Preview {
    ProfileEditView()
}
